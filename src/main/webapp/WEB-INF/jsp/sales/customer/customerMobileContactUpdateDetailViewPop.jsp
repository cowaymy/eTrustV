<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	console.log("customerMobileContactUpdateDetailViewPop");
	$(document).ready(function() {

		if(($("#statusCode").val() == 'A') || ($("#statusCode").val() == 'J')){
			$("#appvBtns").hide();
		}

		$("#btnReject").click(fn_Reject);
		$("#btnApprove").click(fn_Approve);

	});

	function fn_Reject() {
		$("#statusCode").val("J");
		Common.ajax("POST", "/sales/customer/updateAppvStatus.do", $("#formContactUpdate").serializeJSON(), function(result) {
			Common.alert("Information successfully rejected. ");
			fn_selectPstRequestDOListAjax();
			$("#_close").click();
		});
	}

	function fn_Approve() {
		$("#statusCode").val("A");
		Common.ajax("POST", "/sales/customer/updateAppvStatus.do", $("#formContactUpdate").serializeJSON(), function(result) {
			Common.alert("Information successfully updated. ");
			fn_selectPstRequestDOListAjax();
			$("#_close").click();
		});
	}

	function fn_resizefunc(obj, gridName) { //

		var $this = $(obj);
		var width = $this.width()

		AUIGrid.resize(gridName, width, $(".grid_wrap").innerHeight());

	}

</script>

<div id="popup_wrap" class="popup_wrap">
	<form id="getValueForm" method="get">
        <%-- <input type="hidden" id="statusCode" name="statusCode" value="${contactInfo.statusCode}"/> --%>
    </form>
	<header class="pop_header"><!-- pop_header start -->
		<h1>View Contact Info Update Request</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
	</header>

	<section class="pop_body"><!-- pop_body start -->
            <aside class="title_line"><!-- title_line start -->
                <ul class="right_btns">
                    <li><p class="btn_blue blind"></p></li>
                    <li><p class="btn_blue blind"></p></li>
                </ul>
            </aside><!-- title_line end -->
		<form id="formContactUpdate" name="formContactUpdate" enctype="multipart/form-data" action="#" method="post">
            <input type="hidden" id="statusCode" name="statusCode" value="${contactInfo.statusCode}"/>
            <input type="hidden" id="ticketNo" name="ticketNo" value="${contactInfo.ticketNo}"/>
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 160px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Customer Name</th>
						<td>
						      <input id="custName" name="custName" value="${contactInfo.custName}" type="text" title="" placeholder="" class="w100p readonly" readonly />
						</td>
					</tr>
					<tr>
						<th scope="row">Order Number</th>
						<td>
                              <input id="ordNo" name="ordNo" value="${contactInfo.orderNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />
                        </td>
					</tr>
				</tbody>
			</table>
			<aside class="title_line"><!-- title_line start -->
                <ul class="right_btns">
                    <li><p class="btn_blue blind"></p></li>
                    <li><p class="btn_blue blind"></p></li>
                </ul>
            </aside><!-- title_line end -->
			<!-- ============================ Old and New Contact Info Section ============================== -->
			<article class="tap_area"> <!-- tap_area start -->
				<section class="divine2"> <!-- divine3 start -->
					<article>
						<h3>Current Contact Info</h3>
						<table class="type1"><!-- table start -->
							<caption>table</caption>
							<colgroup>
								<col style="width: 140px" />
								<col style="width: *" />
							</colgroup>
							<tbody>
                            <tr>
                                    <th scope="row">HP</th>
                                    <td>
                                        <input type="text"  id="oldHpNo" name="oldHpNo" class="w100p readonly" value="${contactInfo.oldHpNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th scope="row">HOME</th>
                                    <td>
                                        <input type="text"  id="oldHomeNo" name="oldHomeNo" class="w100p readonly" value="${contactInfo.oldHomeNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th scope="row">OFFICE</th>
                                    <td>
                                        <input type="text"  id="oldOfficeNo" name="oldOfficeNo" class="w100p readonly" value="${contactInfo.oldOfficeNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th scope="row">Email</th>
                                    <td>
                                        <input type="text"  id="oldEmail" name="oldEmail" class="w100p readonly" value="${contactInfo.oldEmail}"  maxlength="100"  />
                                    </td>
                            </tr>
							</tbody>
						</table> <!-- table end -->
					</article>

					<article>
						<h3>New Contact Info</h3>
						<table class="type1"><!-- table start -->
							<caption>table</caption>
							<colgroup>
								<col style="width: 140px" />
								<col style="width: *" />
							</colgroup>
							<tbody>
                            <tr>
                                    <th scope="row">HP</th>
                                    <td>
                                        <input type="text"  id="newHpNo" name="newHpNo" class="w100p readonly" value="${contactInfo.newHpNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th scope="row">HOME</th>
                                    <td>
                                        <input type="text"  id="newHomeNo" name="newHomeNo" class="w100p readonly" value="${contactInfo.newHomeNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th rscope="row">OFFICE</th>
                                    <td>
                                        <input type="text"  id="newOfficeNo" name="newOfficeNo" class="w100p readonly" value="${contactInfo.newOfficeNo}"  maxlength="100"  />
                                    </td>
                            </tr>
                            <tr>
                                    <th scope="row">Email</th>
                                    <td>
                                        <input type="text"  id="newEmail" name="newEmail" class="w100p readonly" value="${contactInfo.newEmail}"  maxlength="100"  />
                                    </td>
                            </tr>
							</tbody>
						</table><!-- table end -->
					</article>
				</section><!-- divine2 start -->
			</article><!-- tap_area end -->
		</form>
        <ul id="appvBtns" class="center_btns mt20">
            <li><p class="btn_blue2 big"><a id="btnApprove" href="#">Approve</a></p></li>
            <li><p class="btn_blue2 big"><a id="btnReject" href="#">Reject</a></p></li>
        </ul>
	</section><!-- pop_body end -->
</div>