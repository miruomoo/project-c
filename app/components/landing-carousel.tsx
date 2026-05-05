import Image from "next/image";

const images = [
  { src: "/landing/the-pinnacle-on-adelaide-01.jpg", alt: "The Pinnacle on Adelaide" },
  { src: "/landing/the-bond-condos-290-adelaide-st-original-3.jpg", alt: "The Bond Condos" },
  { src: "/landing/mercerst_ext_s020_street_r01.jpg", alt: "Mercer Street" },
  { src: "/landing/maple-leaf-square-55-65-bremner-blvd-original-9.jpg", alt: "Maple Leaf Square" },
  { src: "/landing/624923698.jpg", alt: "Toronto Condo" },
  { src: "/landing/liberty-market-lofts-original-2.jpg", alt: "Liberty Market Lofts" },
  { src: "/landing/king-condos-01.jpg", alt: "King Condos" },
  { src: "/landing/Aqualuna_1.jpg", alt: "Aqualuna" },
];

const track = [...images, ...images];

export default function LandingCarousel() {
  return (
    <div className="overflow-hidden w-full">
      <div className="flex animate-marquee" style={{ width: "max-content" }}>
        {track.map((img, i) => (
          <div
            key={i}
            className="relative h-56 w-80 mx-2 flex-shrink-0 overflow-hidden rounded-xl"
          >
            <Image
              src={img.src}
              alt={img.alt}
              fill
              draggable={false}
              className="object-cover select-none"
              sizes="320px"
            />
          </div>
        ))}
      </div>
    </div>
  );
}
