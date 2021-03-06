import { Field } from '~/types/form'

export const commonFields: Field[] = [
  {
    name: 'height',
    label: 'Chiều cao (cm)',
    type: 'number',
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
      max: {
        value: 300,
        message: 'Chiều cao không được quả 300cm',
      },
    },
  },
  {
    name: 'weight',
    label: 'Cân nặng (kg)',
    type: 'number',
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
    },
  },
  {
    name: 'sex',
    label: 'Giới tính',
    type: 'select',
    options: ['Nam', 'Nữ'],
    validations: {
      required: {
        value: true,
        message: 'Bạn vui lòng điền trường này',
      },
    },
  },
  {
    name: 'female_only',
    label: 'Dành cho nữ',
    type: 'multi_select',
    showIf: {
      field: ['sex'],
      value: 'Nữ',
    },
    options: ['Đang có thai', 'Đang cho con bú'],
  },
  {
    name: 'thang_co_thai',
    label: 'Đang có thai mấy tháng',
    type: 'number',
    showIf: {
      field: ['sex'],
      value: 'Nữ',
    },
  },
  {
    name: 'dang_cho_con_may_thang_bu',
    label: 'Đang cho con mấy tháng bú',
    type: 'number',
    showIf: {
      field: ['sex'],
      value: 'Nữ',
    },
  },
  {
    name: 'trieu_chung',
    label: 'Triệu chứng',
    type: 'textarea',
  },
  {
    name: 'huyet_ap_trung_binh',
    label: 'Huyết áp trung bình (vd: 110/70)',
    type: 'text',
  },
  {
    name: 'benh_nen',
    label: 'Bệnh nền',
    type: 'multi_select',
    options: [
      'Không',
      'Tiểu đường',
      'Tăng huyết áp',
      'Bệnh gan mạn tính',
      'Bệnh phổi mạn tính',
      'Bệnh tim mạch mạn tính',
      'Bệnh thần kinh',
      'Thừa cân và béo phì',
      'Bệnh máu bẩm sinh',
      'Cấy ghép tạng/tế bào máu gốc',
      'Đột quỵ',
      'Bệnh mạch máu não',
      'Ung thư',
      'Hội chứng Down',
      'Suy giảm miễn dịch',
      'Nhiễm HIV',
      'Khác',
    ],
  },
  {
    name: 'benh_nen_chi_tiet',
    label: 'Mô tả bệnh nền chi tiết',
    type: 'textarea',
  },
  {
    name: 'di_ung_thuoc',
    label: 'Tiền sử dị ứng thuốc',
    type: 'select',
    options: ['Không', 'Có'],
  },
  {
    name: 'di_ung_thuoc_chi_tiet',
    label: 'Mô tả chi tiết tên thuốc/biệt dược dị ứng',
    type: 'textarea',
    showIf: {
      field: ['di_ung_thuoc'],
      value: 'Có',
    },
  },
]

export const assetsLabels = {
  current_symptoms: 'Hình ảnh triệu chứng',
  examination: 'Hình ảnh các kết quả xét nghiệm gần nhất',
  prescription: 'Hình ảnh toa thuốc (hoặc bao thuốc)',
}
