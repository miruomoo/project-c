import Image from "next/image";
import Link from "next/link";

export interface Building {
  id: string;
  building_name: string;
  building_type: "APARTMENT" | "CONDO" | "DETACHED" | "TOWNHOUSE";
  address: string;
  city: string;
  description: string | null;
  cover_image_url: string | null;
}

export default function BuildingCard({ building }: { building: Building }) {
  return (
    <Link
      href={`/buildings/${building.id}`}
      className="group block bg-white border border-[#e5e5e5] rounded-lg overflow-hidden hover:shadow-md transition-shadow duration-200"
    >
      <div className="relative w-full aspect-[4/3] bg-[#f0f0f0]">
        {building.cover_image_url && (
          <Image
            src={building.cover_image_url}
            alt={building.building_name}
            fill
            className="object-cover"
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 25vw"
          />
        )}
      </div>
      <div className="p-5">
        <p className="text-[10px] font-semibold uppercase tracking-widest text-[#a0a0a0] mb-2">
          {building.building_type}
        </p>
        <h3 className="text-[#0f0f0f] font-semibold text-base leading-snug mb-1">
          {building.building_name}
        </h3>
        <p className="text-[#a0a0a0] text-xs">
          {building.address}, {building.city}
        </p>
      </div>
    </Link>
  );
}
