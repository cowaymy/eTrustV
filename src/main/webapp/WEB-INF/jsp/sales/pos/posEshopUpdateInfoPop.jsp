<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}

</style>
<script type="text/javascript">

var myGridIDShipping;
var param= [];

var ItmOption = {
        type: "S",
        isCheckAll: false
};

$(document).ready(function () {


});



function fn_chkItemVal(){

    if(FormUtil.isEmpty($('#courierSvc').val())) {
        Common.alert("Please select the Courier Service. ");
        return false;
    }

    if(FormUtil.isEmpty($('#waybillNo').val())) {
        Common.alert("Please fill in the Waybill No. ");
        return false;
    }

    return true;
}

function fn_promptUpdatePos() {

    if (fn_chkItemVal()) {
        var confirmSaveMsg = "Are you confirm to save with the information?";

        Common.confirm(confirmSaveMsg, updateStatus);
    }

}


function updateStatus() {

       var updateEshopData = {
           esnNo : '${esnNo}',
           courierSvc : $("#courierSvc").val(),
           waybillNo : $("#waybillNo").val()
       };

       Common.ajax("POST", "/sales/posstock/eshopUpdateCourierSvc.do", updateEshopData, function(result) {
          if(result.code == "00") {        //successful update
              Common.alert(" This ESN No: " +  '${esnNo}' + " has been updated.",fn_reloadList());
          } else {
                 Common.alert(result.message,fn_reloadList());
             }
       });
}

function fn_reloadList(){
    location.reload();
}





</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Update Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<section class="search_table mt10"><!-- search_table start -->
<form action="#" method="post" id="form_item">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

 <aside class="title_line"><!-- title_line start -->
      <h3>Update Status:</h3>
    </aside><!-- title_line end -->
    <form action="#" method="post" name="updateForm" id="updateForm">
      <input id="esnNo" name="esnNo" type="hidden" value="" />
      <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width:160px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Courier Service<span class="must">*</span></th>
            <td>
              <select id="courierSvc" name="courierSvc">
                <option value="1392">GDEX</option>
                <option value="1393">ABX</option>
                <option value="1394">POSLAJU</option>
                <option value="1395">CITILINK</option>
                <option value="1396">BY HAND</option>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Waybill No.<span class="must">*</span></th>
            <td><input  type="text" id="waybillNo" name="waybillNo" /></td>
          </tr>
        </tbody>
      </table><!-- table end -->
</form>
</section><!-- search_table end -->



<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="fn_promptUpdatePos()"  ><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</div><!-- popup_wrap end -->