

import * as admin from 'firebase-admin';
import { HttpsError, onCall } from "firebase-functions/v2/https";
//import { Resend } from 'resend';
import { logger } from 'firebase-functions/logger';
if (!admin.apps.length) {
  admin.initializeApp();
}

//const resend = new Resend('confirmation_token_here');

export const bookSeats = onCall(
  { region: "europe-west1" },
  async (request) => {

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
        throw new HttpsError("not-found", "Event not found");
      }

      const event = eventDoc.data();
      const availableSeats = Number(event!.totalSeats ?? 0) - Number(event!.bookedSeats ?? 0);
      const bookedSeats = Number(event!.bookedSeats ?? 0);
      const requestedSeats = Number(seats);

      const existingBooking = await tx.get(bookingRef);
      if (existingBooking.exists) {
        logger.warn("Booking already exists", { userId: request.auth!.uid, eventId });
        throw new HttpsError("already-exists", "Already booked");
      }
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

        throw new HttpsError("failed-precondition", "Not enough seats");
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

    return { success: true };
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

