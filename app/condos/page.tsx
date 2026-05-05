import CondoCard, { type Condo } from "@/app/components/condo-card";

const condos: Condo[] = [
  {
    id: "pinnacle-on-adelaide",
    name: "The Pinnacle on Adelaide",
    neighborhood: "King West",
    address: "22 John St, Toronto, ON",
    rating: 4.1,
    reviewCount: 38,
  },
  {
    id: "liberty-market-lofts",
    name: "Liberty Market Lofts",
    neighborhood: "Liberty Village",
    address: "171 E Liberty St, Toronto, ON",
    rating: 3.7,
    reviewCount: 52,
  },
  {
    id: "maple-leaf-square",
    name: "Maple Leaf Square",
    neighborhood: "Harbourfront",
    address: "55 Bremner Blvd, Toronto, ON",
    rating: 4.4,
    reviewCount: 91,
  },
  {
    id: "the-bond",
    name: "The Bond",
    neighborhood: "Downtown Core",
    address: "290 Adelaide St W, Toronto, ON",
    rating: 3.2,
    reviewCount: 24,
  },
];

export default function CondosPage() {
  return (
    <div className="flex flex-col flex-1 bg-white">
      <section className="max-w-6xl mx-auto w-full px-6 py-16">
        <h1 className="text-3xl font-semibold text-[#0f0f0f] tracking-tight">
          Condos
        </h1>
        <p className="mt-2 text-[#6b6b6b] text-sm">
          Rated by tenants. No landlord edits.
        </p>

        <div className="mt-10 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {condos.map((condo) => (
            <CondoCard key={condo.id} condo={condo} />
          ))}
        </div>
      </section>
    </div>
  );
}
