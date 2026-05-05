import Link from "next/link";

const valueProps = [
  {
    headline: "Skip the surprises.",
    body: "No more finding out about the mould problem after you've signed. Tenants spill the real tea.",
  },
  {
    headline: "Do your homework before you sign.",
    body: "Browse ratings, read reviews, and actually know what you're committing to for the next 12 months.",
  },
  {
    headline: "The vibe check for your next home.",
    body: "From noisy neighbours to responsive supers — real renters rate it all so you don't have to guess.",
  },
];

export default function Home() {
  return (
    <div className="flex flex-col flex-1 bg-white">
      {/* Hero */}
      <section className="flex flex-col items-center justify-center text-center px-6 py-32 md:py-44">
        <p className="text-xs font-semibold uppercase tracking-widest text-[#a0a0a0] mb-6">
          Tenant-sourced. Landlord-proof.
        </p>
        <h1 className="text-5xl md:text-7xl font-semibold text-[#0f0f0f] leading-[1.05] tracking-tight max-w-3xl">
          Know before you rent.
        </h1>
        <p className="mt-6 text-lg text-[#6b6b6b] max-w-xl leading-relaxed">
          Real ratings and reviews from tenants who've been there. No landlord
          spin. No guesswork.
        </p>
        <Link
          href="/condos"
          className="mt-10 inline-block bg-[#0f0f0f] text-white text-sm font-medium px-7 py-3.5 rounded-full hover:bg-[#333] transition-colors"
        >
          Browse condos
        </Link>
      </section>

      {/* Value props */}
      <section className="bg-[#f9f9f9] border-t border-[#e5e5e5] px-6 py-20">
        <div className="max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-12">
          {valueProps.map((prop) => (
            <div key={prop.headline}>
              <h3 className="text-[#0f0f0f] font-semibold text-lg mb-3">
                {prop.headline}
              </h3>
              <p className="text-[#6b6b6b] text-sm leading-relaxed">
                {prop.body}
              </p>
            </div>
          ))}
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-[#e5e5e5] px-6 py-8">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <span className="text-xs text-[#a0a0a0]">
            © {new Date().getFullYear()} project-c
          </span>
          <span className="text-xs text-[#a0a0a0]">
            Built for renters, by renters.
          </span>
        </div>
      </footer>
    </div>
  );
}
