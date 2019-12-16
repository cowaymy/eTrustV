<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  $(document).ready(
    function() {
    	$('#btnPopSave').click(function() {
            // 시리얼 수정 저장
    		fn_saveSerialNoModify();
        });

        $("#btnPopClose").click(function(){
            fn_ClosePop();
        });
    });

function fn_saveSerialNoModify(){

	// 유효성 체크
	if( $("#beforeSerialNo").val().length != 18 ){
		Common.alert("Please, check the Serial No.");
		return false;
	}

	/* if( $("#beforeSerialNo").val() == $("#pSerialNo").val() ){
		Common.alert("Same as the previous Serial No.");
        return false;
	} */

	$("#pBeforeSerialNo").val($("#beforeSerialNo").val());

	var obj = $("#popSerialNoModifyForm").serializeJSON();

    if(Common.confirm("Do you want to save?", function(){
        Common.ajax("POST", "/logistics/serialChange/saveSerialChange.do", obj, function(result) {
			for( var key in result.data ){
			    if( key == "errCode" ){
			        errCode = result.data[key];
			    }
			}
            if(errCode == '000') {
                Common.alert(result.message);
            } else {
                Common.alert(result.message);
            }
            if(result.code == "00"){
                $("#btnPopClose").click();
            }

        });
    }));

}

function fn_ClosePop(){
    // Moblie Popup Setting
    if(Common.checkPlatformType() == "mobile") {
        opener.fn_PopSerialChangeClose();
    } else {
        $('#_serialNoChangePop').remove();
        SearchListAjax();
    }
}
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1> Serial Modification </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="btnPopSave" href="#"><spring:message code='sys.btn.save' /></a>
     <a id="btnPopClose" href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form id="popSerialNoModifyForm" name=""popSerialNoModifyForm"" action="#" method="post">
   <input type="hidden" id="pSerialNo" name="pSerialNo" value="${pSerialNo}" />
   <input type="hidden" id="pBeforeSerialNo" name="pBeforeSerialNo" value="" />
   <input type="hidden" id="pSalesOrdId" name="pSalesOrdId" value="${pSalesOrdId}" />
   <input type="hidden" id="pRetnNo" name="pRetnNo" value="${pRetnNo}" />
   <input type="hidden" id="pStkCode" name="pStkCode" value="${pStkCode}" />
  </form>

     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 160px" />
       <col style="width: *" />
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row">Order No</th>
        <td colspan="5">
         <div >
          <!-- auto_file start -->
            <input type="text" id="salesOrdNo" name="salesOrdNo" class="w95p" readonly = "readonly"  value="${pSalesOrdNo}" />
         </div>
         <!-- auto_file end -->
        </td>
       </tr>
       <tr>
        <th scope="row">Serial No.</th>
        <td colspan="5">
         <div >
          <!-- auto_file start -->
            <input type="text" id="beforeSerialNo" name="beforeSerialNo"  class="w95p" value="${pSerialNo}" />
         </div>
         <!-- auto_file end -->
        </td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->

  <!-- grid_wrap end -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
