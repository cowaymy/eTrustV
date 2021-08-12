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
	if( $("#bSerialNo").val().length != 18 ){
		Common.alert("Please, check the Serial No.");
		return false;
	}

	/* if( $("#beforeSerialNo").val() == $("#pSerialNo").val() ){
		Common.alert("Same as the previous Serial No.");
        return false;
	} */

	$("#popSerialNoModifyForm #pSerialNo").val( $("#bSerialNo").val() );

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
            	$("#popSerialNoModifyForm #pSerialNo").val( $("#pBeforeSerialNo").val() );   // if fail, reverse
                Common.alert(result.message);
            }
            if(result.code == "00"){
                $("#btnPopClose").click();
            }

        },
        errcallback);
    }));

}

function errcallback(jqXHR, textStatus, errorThrown){
	Common.alert(jqXHR.responseJSON.message);
	$("#popSerialNoModifyForm #pSerialNo").val( $("#pBeforeSerialNo").val() );   // if fail, reverse
}

function fn_ClosePop(){

	var obj = {
         asIsSerialNo  : $("#popSerialNoModifyForm #pSerialNo").val(),
         beforeSerialNo : $("#popSerialNoModifyForm #pBeforeSerialNo").val()
     }

	// Moblie Popup Setting
    if(Common.checkPlatformType() == "mobile") {
        opener.fn_PopSerialChangeClose( obj );
    } else {
        $('#_serialNoChangePop').remove();

        SearchListAjax( obj );
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
  <form id="popSerialNoModifyForm" name="popSerialNoModifyForm" action="#" method="post">
   <input type="hidden" id="pSerialNo" name="pSerialNo" value="${pSerialNo}" />
   <input type="hidden" id="pBeforeSerialNo" name="pBeforeSerialNo" value="${pSerialNo}" />
   <input type="hidden" id="pSalesOrdId" name="pSalesOrdId" value="${pSalesOrdId}" />
   <input type="hidden" id="pRefDocNo" name="pRefDocNo" value="${pRefDocNo}" />
   <input type="hidden" id="pItmCode" name="pItmCode" value="${pItmCode}" />
   <input type="hidden" id="pCallGbn" name="pCallGbn" value="${pCallGbn}" />
   <input type="hidden" id="pMobileYn" name="pMobileYn" value="${pMobileYn}" />
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
            <input type="text" id="salesOrdNo" name="salesOrdNo" class="w95p readonly" readonly = "readonly"  value="${pSalesOrdNo}" />
         </div>
         <!-- auto_file end -->
        </td>
       </tr>
       <tr>
        <th scope="row">Serial No.<span name="m5" id="m5" class="must">*</span></th>
        <td colspan="5">
         <div >
          <!-- auto_file start -->
            <input type="text" id="bSerialNo" name="bSerialNo"  class="w95p" value="${pSerialNo}" />
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
