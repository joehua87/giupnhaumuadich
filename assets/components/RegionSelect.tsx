import React, { useEffect, useRef, useState } from 'react'

async function getRegion(text: string) {
  const result = await fetch(
    `https://region.giupnhaumuadich.org/api/region?keyword=${text}`,
  )
  const json = await result.json()
  return json
  // console.log(json)
}

export interface RegionValue {
  geometry: {
    coordinates: [number, number]
    type: string
  }
  name: string
  ward: string
  district: string
  province: string
}

function getRegionName(region: RegionValue) {
  if (!region) {
    return ''
  }
  return [region.name, region.ward, region.district, region.province].join(', ')
}

export function RegionSelect({
  value,
  onChange,
}: {
  value: RegionValue
  onChange: (value: RegionValue | null) => void
}) {
  const ref = useRef<HTMLInputElement>(null)
  const [editable, setEditable] = useState(!value)
  const [keyword, setKeyword] = useState('')
  const [options, setOptions] = useState<RegionValue[]>([])

  useEffect(() => {
    if (keyword.length < 3) {
      setOptions([])
      return
    }
    getRegion(keyword.trim()).then((regions) => {
      setOptions(regions.items)
    })
  }, [keyword])

  return (
    <div className="relative">
      <input
        ref={ref}
        className="input"
        readOnly={!editable}
        placeholder="Gõ ít nhất 3 ký tự để tìm địa chỉ"
        value={editable ? keyword : getRegionName(value)}
        onChange={(e) => {
          setKeyword(e.target.value)
        }}
      />
      {!editable && (
        <button
          className="p-2 transform top-1/2 right-0 -translate-y-1/2 absolute"
          onClick={() => {
            setEditable(true)
            setKeyword('')
            onChange(null)
            ref?.current?.focus()
          }}
        >
          Edit
        </button>
      )}
      <div className="bg-white border shadow-sm transform translate-y-2 absolute">
        {options.map((opt) => (
          <div
            className="border-b cursor-pointer p-2 hover:bg-brand-50"
            key={getRegionName(opt)}
            onClick={() => {
              onChange(opt)
              setEditable(false)
              setKeyword('')
            }}
          >
            {getRegionName(opt)}
          </div>
        ))}
      </div>
    </div>
  )
}
