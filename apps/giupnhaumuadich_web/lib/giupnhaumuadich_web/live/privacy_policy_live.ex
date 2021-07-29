defmodule GiupnhaumuadichWeb.PrivacyPolicyLive do
  use GiupnhaumuadichWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session, false)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="max-w-3xl mx-auto my-6 rich-text">
    <h1 class="heading-1">Chính sách bảo mật</h1>
    <strong>a) Mục đích và phạm vi thu thập</strong>
    <p>Việc thu thập dữ liệu chủ yếu trên website bao gồm: họ tên, email, điện thoại, địa chỉ người dùng trong mục liên hệ. Đây là các thông tin mà chúng tôi cần người dùng cung cấp bắt buộc khi gửi thông tin nhờ tư vấn.</p>
    <p>Người dùng tự chịu trách nhiệm về bảo mật và lưu giữ mọi hoạt động sử dụng dịch vụ dưới thông tin mà mình cung cấp và hộp thư điện tử của mình. Ngoài ra, người dùng có trách nhiệm thông báo kịp thời cho webiste chúng tôi về những hành vi sử dụng trái phép, lạm dụng, vi phạm bảo mật, lưu giữ tên đăng ký và mật khẩu của bên thứ ba để có biện pháp giải quyết phù hợp.</p>
    <strong>b) Phạm vi sử dụng thông tin</strong>
    <p>Chúng tôi sử dụng thông tin người dùng cung cấp để:</p>
    <ul>
    <li>Gửi các thông báo về các hoạt động trên website</li>
    <li>Liên lạc và giải quyết với người dùng trong những trường hợp đặc biệt</li>
    </ul>
    <strong>c) Thời gian lưu trữ thông tin</strong>
    <p>Dữ liệu cá nhân của người dùng sẽ được lưu trữ cho đến khi có yêu cầu ban quản trị hủy bỏ. Còn lại trong mọi trường hợp thông tin cá nhân người dùng sẽ được bảo mật trên máy chủ của chúng tôi</p>
    <strong>d) Những người hoặc tổ chức có thể được tiếp cận với thông tin đó</strong>
    <p>Đối tượng được tiếp cận với thông tin cá nhân của người dùng thuộc một trong những trường hợp sau:</p>
    <ul>
    <li>Quản trị viên của website</li>
    <li>Bác sĩ</li>
    </ul>
    <strong>e) Phương thức và công cụ để người tiêu dùng tiếp cận và chỉnh sửa dữ liệu cá nhân của mình trên hệ thống thương mại điện tử của đơn vị thu thập thông tin</strong>
    <p>Người dùng có quyền tự kiểm tra, cập nhật, điều chỉnh hoặc hủy bỏ thông tin cá nhân của mình bằng cách liên hệ với ban quản trị website thực hiện việc này.</p>
    <p>Người dùng có quyền gửi khiếu nại về nội dung bảo mật thông tin đề nghị liên hệ Ban quản trị của website. Khi tiếp nhận những phản hồi này, chúng tôi sẽ xác nhận lại thông tin, trường hợp đúng như phản ánh của người dùng tùy theo mức độ, chúng tôi sẽ có những biện pháp xử lý kịp thời.</p>
    <p><strong>f) Cơ chế tiếp nhận và giải quyết khiếu nại của người tiêu dùng liên quan đến việc thông tin cá nhân bị sử dụng sai mục đích hoặc phạm vi đã thông báo.</strong></p>
    <p>Thông tin cá nhân của người dùng được cam kết bảo mật tuyệt đối theo chính sách bảo vệ thông tin cá nhân. Việc thu thập và sử dụng thông tin của mỗi người dùng chỉ được thực hiện khi có sự đồng ý của người dùng đó trừ những trường hợp pháp luật có quy định khác.</p>
    <p>Không sử dụng, không chuyển giao, cung cấp hay tiết lộ cho bên thứ 3 nào về thông tin cá nhân của người dùng khi không có sự cho phép đồng ý từ người dùng.</p>
    <p>Trong trường hợp máy chủ lưu trữ thông tin bị hacker tấn công dẫn đến mất mát dữ liệu cá nhân người dùng, chúng tôi sẽ có trách nhiệm thông báo vụ việc cho cơ quan chức năng điều tra xử lý kịp thời và thông báo cho người dùng được biết.</p>
    </div>

    """
  end
end
