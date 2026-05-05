import Link from "next/link";

export interface Condo {
  id: string;
  name: string;
  neighborhood: string;
  address: string;
  rating: number;
  reviewCount: number;
}

function StarRating({ rating }: { rating: number }) {
  const full = Math.floor(rating);
  const half = rating % 1 >= 0.5;
  const empty = 5 - full - (half ? 1 : 0);

  return (
    <span className="text-[#0f0f0f] text-sm" aria-label={`${rating} out of 5`}>
      {"★".repeat(full)}
      {half ? "½" : ""}
      {"☆".repeat(empty)}
    </span>
  );
}

export default function CondoCard({ condo }: { condo: Condo }) {
  return (
    <Link
      href={`/condos/${condo.id}`}
      className="group block bg-white border border-[#e5e5e5] rounded-lg p-5 hover:shadow-md transition-shadow duration-200"
    >
      <p className="text-[10px] font-semibold uppercase tracking-widest text-[#a0a0a0] mb-2">
        {condo.neighborhood}
      </p>
      <h3 className="text-[#0f0f0f] font-semibold text-base leading-snug mb-1">
        {condo.name}
      </h3>
      <p className="text-[#a0a0a0] text-xs mb-4">{condo.address}</p>
      <div className="flex items-center gap-2">
        <StarRating rating={condo.rating} />
        <span className="text-[#0f0f0f] text-sm font-medium">{condo.rating.toFixed(1)}</span>
        <span className="text-[#a0a0a0] text-xs">({condo.reviewCount} reviews)</span>
      </div>
    </Link>
  );
}
