import type { Metadata } from "next";
import { Inter, Playfair_Display } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-sans",
  subsets: ["latin"],
  display: "swap",
});

const playfair = Playfair_Display({
  variable: "--font-serif",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "DEEP SORTING | Klasifikasi Sampah Plastik — IPB University",
  description:
    "Proyek Visual Komputer Cerdas IPB University Kelompok 7: Klasifikasi jenis sampah plastik (PET, HDPE, PVC, LDPE, PP, PS, Other) berbasis CNN dan Transfer Learning.",
  keywords: [
    "klasifikasi sampah plastik",
    "deep learning",
    "transfer learning",
    "IPB University",
    "computer vision",
    "MobileNetV2",
    "VGG16",
    "daur ulang plastik",
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="id" className={`${inter.variable} ${playfair.variable} scroll-smooth`}>
      <body className="min-h-screen flex flex-col bg-[#F7F7F2] text-[#172626] antialiased">
        {children}
      </body>
    </html>
  );
}
