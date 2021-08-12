<!--=================================================================================================
* Task  : Logistics
* File Name : stockAuditOtherPop.jsp
* Description : Stock Audit Other GI/GR
* Author : KR-OHK
* Date : 2019-10-21
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-21 KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var itemGrid;

    var itemColumnLayout=[
                          {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                          {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                          {dataField: "otherReqstNo",headerText :"<spring:message code='log.head.othersrequestno'/>", width: 140 },
                          {dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 100 },
                          {dataField: "locType",headerText :"<spring:message code='log.head.locationtype'/>", width: 120},
                          {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120},
                          {dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 150, style: "aui-grid-user-custom-left"},
                          {dataField: "otherTrnscTypeNm",headerText :"<spring:message code='log.head.transactiontype'/>" ,width:130, editable : false},
                          {dataField: "otherTrnscTypeDtlNm",headerText :"<spring:message code='log.head.movementtype'/>" ,width:150, editable : false},
                          {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:110, editable : false},
                          {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 100, editable : false},
                          {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 170, editable : false, style: "aui-grid-user-custom-left"},
                          {dataField: "qty",headerText :"<spring:message code='log.head.availableqty'/>", width:110, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "otherQty",headerText :"<spring:message code='log.head.requestqty'/>", width:110, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "uom",headerText :"<spring:message code='log.head.uom'/>", width:80, editable : false}
                  ];

    var itemop = {
            //rowIdField : "rnum",
            showRowCheckColumn : false,
            editable : false,
            usePaging : false, //페이징 사용
            showStateColumn : false,
            headerHeight: 35,
            selectionMode : "singleCell"
            };

    $(document).ready(function () {

    	var result = $.parseJSON('${itemList}');

        itemGrid = GridCommon.createAUIGrid("other_item_grid_wrap_pop", itemColumnLayout,"", itemop);
        AUIGrid.setGridData(itemGrid, result);

	    if(FormUtil.isEmpty(result[0].otherReqstRequireDt)) {
        	doSysdate(0, 'reqstDt');
        } else {
        	$("#reqstDt").val(result[0].otherReqstRequireDt);
        }

	    $("#otherRem").val(result[0].otherRem);

        if('${docInfo.docStusCodeId}' != '5681') { // 3rd Approval
        	 $("#pop_header_title").text("Other GI /GR Detail");
    	}

        $('#save').click(function() {

            if ( true == $(this).parents().hasClass("btn_disabled") ) {
                return  false;
            }

            if(FormUtil.checkReqValue($("#reqstDt"),false)){
            	text = "<spring:message code='log.label.rqstDt'/>";
                Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
                return false;
            }


            if(FormUtil.checkReqValue($("#otherRem"))){
                text = "<spring:message code='log.head.remark'/>";
                Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
                return false;
            }

            var length = AUIGrid.getGridData(itemGrid).length;
            var otherCnt = 0;

            if(length > 0) {
                for(var i = 0; i < length; i++) {
                    if(AUIGrid.getCellValue(itemGrid, i, "otherQty") == '0') {
                        otherCnt ++;
                    }
                }
            }

            if(length == otherCnt) {
            	 Common.alert("Request quantity is zero.");
                 return false;
            }

            var obj = $("#appvForm").serializeJSON();
            obj.stockAuditNo = $("#hidStockAuditNo").val();
            obj.appvType = "other";
            obj.reuploadYn = $("#hidReuploadYn").val();

            Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
                if(result != null) {
                    if(result.updDtTime != $("#hidUpdDtTime").val()) {
                        Common.alert("The data you have selected is already updated.");
                        return false;
                    } else {
                    	if(Common.confirm("Do you want to generate GI/GR?", function(){
                            Common.ajax("POST", "/logistics/adjustment/saveOtherGiGr.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                                 Common.alert(result.message);
                                 fn_selectAduitOtherAjax();
                            });
                        }));
                    }
                }
            });
        });

        $('#popClose').click(function() {
        	 if($("#hidDocStusCodeId").val() == '5683' || $("#hidDocStusCodeId").val() == '5684') { // Other GI / GR, Complete
        		  getListAjax(1);
        	 }
        });
    });

    function fn_selectAduitOtherAjax() {
    	var obj = $("#appvForm").serializeJSON();
    	obj.stockAuditNo = $("#hidStockAuditNo").val();
        Common.ajax("GET", "/logistics/adjustment/selectOtherDetail", obj, function (result) {

        	$("#btnSave").addClass("btn_disabled");
        	$("#hidDocStusCodeId").val(result.data);

            AUIGrid.setGridData(itemGrid, result.dataList);
        });
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1 id="pop_header_title">New Other GI / GR</h1>
        <ul class="right_opt">
            <li><p id="btnSave" class="btn_blue2 <c:if test="${docInfo.docStusCodeId != '5681'}"> btn_disabled</c:if>"><a id="save">Generate GI / GR</a></p></li>
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <form id="appvForm" name="appvForm" >
              <input type="hidden" id="hidStockAuditNo" name="hidStockAuditNo" value="${docInfo.stockAuditNo}">
              <input type="hidden" id="hidReuploadYn" name="hidReuploadYn" value="${docInfo.reuploadYn}">
              <input type="hidden" id="hidDocStusCodeId" name="hidDocStusCodeId">
              <input type="hidden" id="hidUpdDtTime" name="hidUpdDtTime" value="${docInfo.updDtTime}">
 			  <table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
					    <td>${docInfo.stockAuditNo}</td>
					     <th scope="row"><spring:message code='log.label.rqstDt'/><span class="must">*</span></th>
					     <td>
					       <div class="date_set w100p"><!-- date_set start -->
						     <p><input type="text" id="reqstDt" name="reqstDt"  placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
						   </div><!-- date_set end -->
					     </td>
					</tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.remark'/><span class="must">*</span></th>
	                     <td colspan='3'><input type="text" name="otherRem" id="otherRem" value="${result[0].otherRem}" class="w100p"/></td>
	                 </tr>
				</tbody>
			</table>
        </form>

		<section class="search_result"><!-- search_result start -->

            <aside class="title_line"><!-- title_line start -->
	           <h3>Request Item</h3>
	        </aside><!-- title_line end -->

            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="other_item_grid_wrap_pop" style="width:100%; height:570px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

        </section><!-- search_result end -->

    </section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->
