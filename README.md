# Matchmaker AI — iOS app, manual only

Isolated iOS app for the Snapchat Guntur Matchmaker approval-only workflow.
It does NOT disturb any other project. It does NOT log into Snapchat.

## What it does
- Add a contact manually only: username you type, basis (she contacted you
  first / already mutual-accepted / you already know her personally),
  adult status voluntarily confirmed (required before saving).
- Draft the exact Roman Urdu opening for your approval. You copy it and
  send it yourself in Snapchat. This app never sends anything.
- Disclosure + AI-consent gate: no further draft until she explicitly
  agrees to AI-assisted chat. Declined = closed.
- Guntur filter: "Aap Guntur se ho kya?" — volunteered answer only.
  Outside Guntur = romantic track ends politely. No exact home address.
- Compatibility tracking on observed evidence only: incoming messages,
  positive signals, mutual effort, mutual romantic interest, serious
  intention, plus volunteered age/religion/location (unknown until
  volunteered, never guessed from a name or photo).
- Promising notification + pause when ALL thresholds are met: adult
  confirmed + Muslim volunteered + Guntur confirmed + mutual interest
  + serious intention + >=4 incoming + >=3 positive + mutual effort
  + AI consent yes. Then you take over personally.
- Intimacy values only with her permission; declined closes the topic.
  Marriage expectations recorded only as stated; elopement never
  required, no pressure.
- Pause/resume and delete-all data, stored on the phone only.

## What it cannot do
1. Discover Snapchat friends, send friend requests, read chats, or send
   messages automatically — there's no permitted Snapchat integration
   for that, and I won't use an unofficial login to fake it.
2. Guess religion, age, or location from a name or photo — those stay
   "unknown" until she volunteers them.
3. Run daily on its own hunting for matches, or keep running on GitHub
   until you have a girlfriend.

## Build
- Version 1.0.0 build 1, bundle com.shaik.matchmaker, display Matchmaker AI.
- GitHub Actions workflow "Matchmaker tests and unsigned IPA" builds an
  UNSIGNED .ipa. Install from Windows with Sideloadly or AltStore,
  which sign it with your Apple ID. No IPA is claimed until that
  workflow actually produces one and its contents are verified.
