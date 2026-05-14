import Link from "next/link";

export default function Nav() {
  return (
    <header className="sticky top-0 z-50 bg-white border-b border-[#e5e5e5]">
      <div className="max-w-6xl mx-auto px-6 h-14 flex items-center justify-between">
        <Link
          href="/"
          className="text-[#0f0f0f] font-semibold text-sm tracking-tight hover:opacity-70 transition-opacity"
        >
          project-c
        </Link>
        <nav className="flex items-center gap-6">
          <Link
            href="/buildings"
            className="text-[#6b6b6b] text-sm hover:text-[#0f0f0f] transition-colors"
          >
            Buildings
          </Link>
        </nav>
      </div>
    </header>
  );
}
