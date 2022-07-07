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

var myRetrunGridIDPOSEshop;

var columnLayout = [
                    {dataField: "stkCode" ,headerText :"Item" , width:250 ,height:30 , visible:true, editable : true},
                    {dataField: "itemPrice" ,headerText :"Unit Price" ,width:140 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemQty" ,headerText :"Total Quantity (pcs)"  ,width:120 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                    {dataField: "itemOrdQty" ,headerText :"Total Carton" ,width:120 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                    {dataField: "itemWeight" ,headerText :"Weight (Carton)" ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "totalPrice" ,headerText :"Total(RM)" ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "itemCode" ,headerText :"itemCode" ,width:120   ,height:30 , visible:false, editable : false}
 ];



//그리드 속성 설정
var gridProsPOS = {
        usePaging : true,
        pageRowCount : 10,
        editable : true
//         showRowCheckColumn : true
};





$(document).ready(function () {


	createAUIGrid();


});



function createAUIGrid(){

        // 실제로 #grid_wrap 에 그리드 생성
        myRetrunGridIDPOSEshop = AUIGrid.create("#grid_wrap_approval", columnLayout, gridProsPOS);
        var grandTotal = 0;

        Common.ajax("GET", "/sales/posstock/selectPosEshopApprovalViewList.do?esnNo="+'${esnNo}', null, function(result) {

            AUIGrid.setGridData(myRetrunGridIDPOSEshop, result);
            $("#contactName").val(result[0].esnContactPic);
            $("#contactNo").val(result[0].esnContactNo);
            $("#addrDtl").val(result[0].esnAddr1);
            $("#streetDtl").val(result[0].esnAddr2);
            $("#mArea").val(result[0].esnArea);
            $("#mCity").val(result[0].esnCity);
            $("#mPostCd").val(result[0].esnPostcode);
            $("#mState").val(result[0].esnState);
            $("#mCountry").val(result[0].esnCountry);
            $("#totalShippingFee").val(result[0].shippingFee);

            for(var i=0; i<result.length;i++){
            	grandTotal +=Number(result[i].totalPrice);
            }
            $("#totalPrice").val(Number(grandTotal)+Number(result[0].shippingFee));
            $("#attachId").val(result[0].atchFileId);
            $("#crtId").val(result[0].crtId);
        });

}

//리스트 조회.
function fn_getApprovalDataListAjax  () {

  Common.ajax("GET", "/sales/posstock/selectPosEshopApprovalList.do?esnNo="+'${esnNo}', null, function(result) {

     AUIGrid.setGridData(myRetrunGridIDPOS, result);

 });
}


function fn_close(){
    $("#popup_wrap").remove();
}


function fn_viewAttachPop(){
    window.open("<c:url value='/file/fileDown.do?fileId="+  $("#attachId").val()+ "'/>");

}

function fn_approveEshop(){

	   var data = {};
	   data.esnNo = '${esnNo}';
       data.form = $("#form").serializeJSON();


	    Common.ajax("POST", "/sales/posstock/insertPos.do", data, function(result) {

              if(result.logError == "000"){
                      Common.alert('<spring:message code="sal.alert.msg.posSavedShowRefNo" arguments="'+result.reqDocNo+'" />',fn_close());
              }
              else{
                    Common.alert("fail : Contact Logistics Team")
              }
        });

}


function fn_rejectEshop(){
	   Common.popupDiv("/sales/posstock/rejectPosEshopPop.do?esnNo="+'${esnNo}');
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Approval</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="form">
<section>
        <aside class="title_line">
            <h3>Contact Info</h3>
        </aside>

        <section>
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 120px" />
                        <col style="width: *" />
                        <col style="width: 120px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="sal.text.name" /></th>
                            <td colspan="3"><input id="contactName" name="contactName" type="text" class="w100p readonly" readonly /></td>
                        </tr>

                        <tr>
                            <th scope="row">Tel (Mobile)<span class="must">*</span></th>
                            <td colspan="3"><input id="contactNo" name="contactNo" type="text" class="w100p readonly" readonly /></td>
                        </tr>
                    </tbody>
                </table>
        </section>
</section>

<section>
        <aside class="title_line">
                <h3>Shopping Address Info</h3>
        </aside>

        <section>

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 120px" />
                        <col style="width: *" />
                        <col style="width: 120px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                            <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
                            <td colspan="3"><input type="text" title="" id="addrDtl" name="addrDtl"  class="w100p readonly" readonly /></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="sal.text.street" /></th>
                            <td colspan="3"><input type="text" title="" id="streetDtl" name="streetDtl" class="w100p readonly" readonly /></td>
                        </tr>
                       <tr>
                            <th scope="row"><spring:message code="sal.text.area" /></th>
                            <td colspan="3"><input type="text" title="" id="mArea" name="mArea"  class="w100p readonly" readonly /></td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code="sal.text.city" /></th>
                            <td><input type="text" title="" id="mCity" name="mCity"  class="w100p readonly" readonly /></td>
                             <th scope="row"><spring:message code="sal.text.postCode" /></th>
                            <td><input type="text" title="" id="mPostCd" name="mPostCd"  class="w100p readonly" readonly /></td>
                        </tr>

                        <tr>
                            <th scope="row"><spring:message code="sal.text.state" /></th>
                            <td><input type="text" title="" id="mState" name="mState"  class="w100p readonly" readonly /></td>

                             <th scope="row"><spring:message code="sal.text.country" /></th>
                            <td><input type="text" title="" id="mCountry" name="mCountry"  class="w100p readonly" readonly /></td>
                        </tr>
                    </tbody>
                </table>
        </section>
</section>

<div id="grid_wrap_approval" class="mt10" style="height:200px;"></div>

        <section class="mt20">
                    <!-- title_line start -->
                    <aside class="title_line"><h2>Summary Ordering</h2></aside>
                    <!-- title_line end -->

                    <table class="type1 mt10">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
<!--                            <col style="width: 150px" /> -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Shipping Fee</th>
                                <td><input type="text"  id="totalShippingFee" name="totalShippingFee" class="w100p readonly" readonly /></td>
                            </tr>
                            <tr>
                                <th scope="row">Grand Total Price</th>
                                <td><input type="text" id="totalPrice" name="totalPrice" class="w100p readonly" readonly /></td>
                            </tr>
                              <tr>
                               <th scope="row">Attachment</th>
							    <td colspan="3">

							        <ul class="right_btns">
                                        <input id="attachId" name="attachId" type="hidden" />
							            <li><p class="btn_grid"  id="itemAttachmentBt" ><a id="itemAttachment" onclick="fn_viewAttachPop();" >View</a></p></li>
							        </ul>

							    </td>
                            </tr>


                        </tbody>
                    </table>
                    <input type="hidden" id="hiddenAttachmentPaySlip" name="hiddenAttachmentPaySlip"/>
                    <input id="crtId" name="crtId" type="hidden" />
                    <ul class="center_btns">
	                    <li><p class="btn_blue"><a href="#" onclick="fn_approveEshop()">Approve</a></p></li>
	                    <li><p class="btn_blue"><a href="#" onclick="fn_rejectEshop()">Reject</a></p></li>
            </ul>

        </section>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->