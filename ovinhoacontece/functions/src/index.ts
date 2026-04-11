

import * as admin from 'firebase-admin';
import { HttpsError, onCall } from "firebase-functions/v2/https";
//import { Resend } from 'resend';
import { logger } from 'firebase-functions/logger';
import { Filter, Query } from 'firebase-admin/firestore';

if (!admin.apps.length) {
  admin.initializeApp();
}

//const resend = new Resend('confirmation_token_here');

export const searchEvents = onCall(
  { region: "europe-west1" },
  async (request) => {
    const location: String = request.data.location;

    const db = admin.firestore();
    const eventsRef = db.collection("events");
    const q: Query = eventsRef
      .where("date", ">=", admin.firestore.Timestamp.now())

    if (location && typeof location === 'string' && location.trim() !== '') {
      logger.info("Querying events with location filter", { location });

      q.where(Filter.or(Filter.where("location.district", "==", location),
        Filter.where("location.municipality", "==", location)));

      logSearchResults(location);
    }

    const snapshot = await q.get();

    const entities = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    return { success: true, entities };

  });

const logSearchResults = async (location: string) => {
  const searchLogsRef = admin.firestore().collection("searchLogs");

  try {
    const searchLogsSnapshot = await searchLogsRef.where("location", "==", location).get();
    const now = admin.firestore.FieldValue.serverTimestamp();

    if (searchLogsSnapshot.empty) {
      searchLogsRef.add({
        location: location,
        lastSearchTimestamp: now,
        count: 1,
        timestamps: [now]
      });
    } else {
      const doc = searchLogsSnapshot.docs[0];

      doc.ref.update({
        lastSearchTimestamp: now,
        count: admin.firestore.FieldValue.increment(1),
        timestamps: admin.firestore.FieldValue.arrayUnion(now)
      });
    }
  } catch (err) {
    logger.error("Failed to log search query", { location, error: err });
  }
}

export const bookSeats = onCall(
  { region: "europe-west1" },
  async (request) => {
    /*   try { */
    logger.info("Booking request received", {
      userId: request.auth?.uid || "unauthenticated",
      eventId: request.data?.eventId || "missing",
      seats: request.data?.seats || "missing"
    });
    if (!request.auth) {
      logger.warn("Unauthenticated booking attempt");
      throw new HttpsError("unauthenticated", "Login required");
    }

    const { eventId, seats, name, email, phone } = request.data;

    if (!eventId || !seats || !email || !name) {
      logger.warn("Invalid booking data", { eventId, seats, name, email });
      throw new HttpsError("invalid-argument", "Missing data");
    }

    const db = admin.firestore();
    const eventRef = db.collection("events").doc(eventId);
    const bookingRef = eventRef
      .collection("bookings")
      .doc(request.auth!.uid);

    await db.runTransaction(async (tx) => {
      const eventDoc = await tx.get(eventRef);

      if (!eventDoc.exists) {
        logger.warn("Event not found", { eventId });
        throw new HttpsError("not-found", "event-not-found");
      }

      const event = eventDoc.data();
      const availableSeats = Number(event!.totalSeats ?? 0) - Number(event!.bookedSeats ?? 0);
      const bookedSeats = Number(event!.bookedSeats ?? 0);
      const requestedSeats = Number(seats);

      /* const existingBooking = await tx.get(bookingRef);
      if (existingBooking.exists) {
        logger.warn("Booking already exists", { userId: request.auth!.uid, eventId });
        throw new HttpsError("already-exists", "booking-already-exists");
      } */
      logger.info("Processing booking", {
        userId: request.auth!.uid,
        eventId,
        requestedSeats,
        availableSeats,
        bookedSeats
      });
      if (requestedSeats > availableSeats) {
        // Log overbooking attempt
        await eventRef.collection('overbookings').add({
          userId: request.auth!.uid,
          name: name.trim(),
          email: email.trim().toLowerCase(),
          phone: phone ? phone.trim() : null,
          requestedSeats: requestedSeats,
          timestamp: admin.firestore.FieldValue.serverTimestamp()
        });

        throw new HttpsError("failed-precondition", "not-enough-seats");
      }

      tx.set(bookingRef, {
        userId: request.auth!.uid,
        name: name.trim(),
        phone: phone ? phone.trim() : null,
        email: email.trim().toLowerCase(),
        requestedSeats: requestedSeats,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });

      tx.update(eventRef, {
        bookedSeats: bookedSeats + requestedSeats
      });
    });

    return { success: true, messageKey: "booking-submitted" };
    /* } catch (error) {
      const errorName = (error as any).name;
      const isOvaInstanceof = error instanceof OvaException;
      const errorProto = Object.getPrototypeOf(error);
      const ovaProtoMatch = errorProto === OvaException.prototype;
      
      const isOva = errorName === 'OvaException' && typeof (error as any).code === 'string';
      
      if (isOva) {
        return { success: false, messageKey: (error as any).code };
      } 
      
      // Log only non-Ova errors to avoid circular logger error
      logger.error("Unexpected error processing booking", {
        isOvaInstanceof,
        errorName,
        ovaProtoMatch,
        errorProtoName: errorProto?.constructor?.name,
        code: (error as any).code,
        message: error instanceof Error ? error.message : String(error),
        err: error
      });
      
      return { success: false, messageKey: "unknown-error" };
    } */


  }
);

/* import { onDocumentCreated } from "firebase-functions/v2/firestore";


export const sendBookingEmail = onDocumentCreated(
  "events/{eventId}/bookings/{bookingId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

      await resend.emails.send({
        to: data.email,
        subject: "Booking Confirmed",
        html: `<p>Hi ${data.name}, your booking is confirmed.</p>`
      });
  }
);
 */
/* // New callable: process lead server-side (call from Flutter for validation/email)
export const processLead = onCall(async (request: CallableRequest) => {
  const { leadId, lang, email } = request.data;
  if (!['pt', 'en'].includes(lang)) {
    throw new Error('Invalid language: must be pt or en');
  }
  logger.info('Processing lead:', { leadId, lang, email });
  // TODO: Send email, update status, etc. Use admin.firestore()
  return { success: true, processed: true };
});

// Trigger on new lead creation in 'leads' collection
export const onLeadCreated = onDocumentCreated(
  'leads/{leadId}',
  async (event) => {
    const data = event.data?.data();
    if (!data) {
      logger.error('No data in lead document');
      return;
    }

    logger.info('New lead created:', {
      leadId: event.params.leadId,
      lang: data.lang || 'unknown',
      email: data.email || 'no email'
    });

    // Example validation: ensure lang is pt or en
    if (!['pt', 'en'].includes(data.lang)) {
      logger.warn('Invalid lang in lead, consider rejecting');
      // Could add validation logic here, e.g., delete invalid doc
    }

    // TODO: Send email, notify admin, etc.
  }
); */

// Placeholder for future triggers
/*
export const onBookingCreated = onDocumentCreated('events/{eventId}/bookings/{bookingId}', (event) => {
  // Handle new booking
});
*/
/* 

class OvaException extends HttpsError {
  constructor(code: string, message: string) {
    super(code as any, message);
    this.name = 'OvaException';
    Object.setPrototypeOf(this, OvaException.prototype);
  }
}
 */