import React, { ReactNode, useState, useRef, useEffect } from 'react'
import { useCombobox } from 'downshift'
import { Icon } from './Icon'

export function DataSelect<T>({
  items,
  renderItem,
  filterFn,
  value,
  onChange,
}: {
  items: T[]
  renderItem: (item: T) => ReactNode
  filterFn: (item: T, inputValue: string) => boolean
  value?: T
  onChange: (value?: T | null) => void
}) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [inputValue, setInputValue] = useState('')
  const [inputItems, setInputItems] = useState(items)
  const {
    isOpen,
    getToggleButtonProps,
    getLabelProps,
    getMenuProps,
    getInputProps,
    getComboboxProps,
    highlightedIndex,
    getItemProps,
    selectItem,
  } = useCombobox({
    inputValue,
    items: inputItems,
    selectedItem: value,
    onSelectedItemChange: ({ selectedItem }) => {
      setInputValue('')
      onChange(selectedItem)
    },
    onInputValueChange: ({ inputValue }) => {
      setInputItems(
        items.filter((item) => filterFn(item, inputValue || '')).slice(0, 12),
      )
    },
  })

  useEffect(() => {
    if (isOpen) {
      inputRef.current?.focus()
    }
  }, [isOpen])

  return (
    <div className="relative">
      <div className="flex">
        <button
          type="button"
          className="border flex px-2 text-gray-700 w-64 justify-between"
          {...getToggleButtonProps()}
          aria-label="toggle menu"
        >
          {value ? renderItem(value) : 'Vui lòng chọn'}
          <Icon icon="chevron-down" className="text-gray-500" />
        </button>
        {/* {value && (
          <button
            type="button"
            onClick={() => {
              selectItem(null as any)
            }}
          >
            <Icon icon="x" />
          </button>
        )} */}
      </div>
      <div
        style={{ display: isOpen ? 'block' : 'none' }}
        className="bg-white border rounded top-full shadow-sm p-2 transform w-64 z-10 translate-y-2 absolute"
      >
        <div style={{}} {...getComboboxProps()}>
          <input
            className="input"
            placeholder="Tìm người dùng..."
            {...getInputProps({
              ref: inputRef,
              value: inputValue,
              onChange: (e) => setInputValue(e.currentTarget.value),
            })}
          />
        </div>
        <ul {...getMenuProps()} className="mt-2">
          {inputItems.map((item, index) => (
            <li
              style={
                highlightedIndex === index ? { backgroundColor: '#bde4ff' } : {}
              }
              className="cursor-pointer w-full py-1 px-2 not-last:border-b"
              key={`${item}${index}`}
              {...getItemProps({ item, index })}
            >
              {renderItem(item)}
            </li>
          ))}
        </ul>
      </div>
    </div>
  )
}
