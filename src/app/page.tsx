import { Navbar } from "@/components/layout/Navbar";
import { HeroSection } from "@/components/landing/HeroSection";
import { ClassifierContainer } from "@/components/classifier/ClassifierContainer";
import { DatasetSection } from "@/components/dataset/DatasetSection";
import { MethodologySection } from "@/components/methodology/MethodologySection";
import { EvaluationSection } from "@/components/evaluation/EvaluationSection";
import { AboutSection } from "@/components/about/AboutSection";
import { Footer } from "@/components/layout/Footer";

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow">
        <HeroSection />
        <ClassifierContainer />
        <DatasetSection />
        <MethodologySection />
        <EvaluationSection />
        <AboutSection />
      </main>
      <Footer />
    </div>
  );
}
