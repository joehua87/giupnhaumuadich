import React, { useState, ReactNode } from 'react'
import { useCombobox, useMultipleSelection } from 'downshift'
import { Icon } from './Icon'

export function MultiDataSelect<T>({
  items,
  value,
  onChange,
  renderItem,
  filterFn,
}: {
  items: T[]
  value: T[]
  onChange: (value: T[]) => void
  renderItem: (item: T) => ReactNode
  filterFn: (item: T, inputValue: string) => boolean
}) {
  const [inputValue, setInputValue] = useState('')

  const {
    getSelectedItemProps,
    getDropdownProps,
    addSelectedItem,
    removeSelectedItem,
    selectedItems,
  } = useMultipleSelection({
    initialSelectedItems: value || [],
    onStateChange: ({ selectedItems }) => {
      if (!selectedItems) {
        return
      }
      onChange(selectedItems)
    },
  })

  const getFilteredItems = (items: T[]) =>
    items.filter((item) => filterFn(item, inputValue)).slice(0, 12)

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
  } = useCombobox<T | null>({
    inputValue,
    items: getFilteredItems(items),
    onStateChange: ({ inputValue, type, selectedItem }) => {
      switch (type) {
        // case useCombobox.stateChangeTypes.InputChange:
        //   console.log({ inputValue })
        //   setInputValue(inputValue || '')
        //   break
        case useCombobox.stateChangeTypes.InputKeyDownEnter:
        case useCombobox.stateChangeTypes.ItemClick:
        case useCombobox.stateChangeTypes.InputBlur:
          if (selectedItem) {
            setInputValue('')
            addSelectedItem(selectedItem)
            selectItem(null)
          }
          break
        default:
          break
      }
    },
  })

  return (
    <div>
      {/* <label {...getLabelProps()}>Choose some elements:</label> */}
      <div>
        <div>
          {selectedItems.map((selectedItem, index) => (
            <span
              key={`selected-item-${index}`}
              className="mr-1 mb-1 tag"
              {...getSelectedItemProps({ selectedItem, index })}
            >
              {renderItem(selectedItem)}
              <span
                className="ml-1"
                onClick={() => removeSelectedItem(selectedItem)}
              >
                &#10005;
              </span>
            </span>
          ))}
        </div>
        <div
          className="border rounded flex px-2 text-gray-700 items-center inline-flex relative"
          {...getComboboxProps()}
        >
          <input
            className="focus:outline-none"
            placeholder="Add new"
            {...getInputProps(
              getDropdownProps({
                preventKeyAction: isOpen,
                onChange: (e) => {
                  setInputValue(e.target.value)
                },
              }),
            )}
          />
          <button
            {...getToggleButtonProps()}
            aria-label={'toggle menu'}
            type="button"
          >
            <Icon icon="chevron-down" className="text-gray-500" />
          </button>
          <ul
            {...getMenuProps()}
            className="bg-white rounded top-full shadow-sm transform z-10 translate-y-2 absolute"
          >
            {isOpen &&
              getFilteredItems(items).map((item, index) => (
                <li
                  className="py-1 px-2 w-48 not-last:border-b"
                  style={
                    highlightedIndex === index
                      ? { backgroundColor: '#bde4ff' }
                      : {}
                  }
                  key={`${item}${index}`}
                  {...getItemProps({ item, index })}
                >
                  {renderItem(item)}
                </li>
              ))}
          </ul>
        </div>
      </div>
    </div>
  )
}
