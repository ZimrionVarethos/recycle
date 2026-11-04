# design.md — Design System

## Acuan PDF KELOMPOK_7.pdf
- Halaman 1 dan 7: deep teal/dark green background, off-white heading, gold accents.
- Halaman 2–6: off-white background, teal headings/cards, gold highlights.
- Motif: curved wave shapes, plastic bottle/recycling imagery.
- Visual tone: academic, eco-tech, elegant, trustworthy. Jangan cyberpunk/neon.

## Palette (approximation from PDF)
```css
:root {
  --deep-teal: #003B3A;
  --dark-teal: #004B49;
  --teal: #087E78;
  --teal-light: #2A9D8F;
  --gold: #F4B323;
  --gold-dark: #D99A0B;
  --off-white: #F7F7F2;
  --white: #FFFFFF;
  --ink: #172626;
  --muted: #5E6B68;
  --border: #DCE5E1;
  --success: #247A53;
  --error: #B42318;
}
```
These are approximated digital colors, not exact sampled original design values.

## Typography
- Editorial serif for headings: Playfair Display / DM Serif Display.
- UI/body sans-serif: Inter / Geist.
- Strong readable contrast; avoid ornate type in controls.

## Components & layout
- Navbar: Home, Classifier, Model, Dataset, Methodology, About.
- Hero: title, project summary, CTA.
- Classifier: upload/camera area and result panel.
- Result: class, confidence, explanation, optional Grad-CAM, retry.
- Seven class cards.
- Methodology: CNN custom, VGG16, MobileNetV2, augmentation, class weights.
- Dataset and evaluation: metrics with source/experiment labels.
- About and limitations.
- Footer with academic project disclaimer.

## UI states
- Empty, preview, loading, success, error, demo/mock.
- Mock state visibly marked “Demo”.
- No placeholder metric pretending to be real.

## Styling
- Deep teal for hero/footer/strong sections.
- Off-white/light backgrounds for readable content.
- Gold is accent only.
- Moderate border radius, subtle shadows, ample whitespace.
- Relevant plastic/recycling visuals.
- Lucide outline icons; avoid emoji as primary UI icons.
- Responsive mobile-first; reduced-motion support.
- WCAG-conscious contrast and visible keyboard focus.
