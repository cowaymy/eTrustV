<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
	
	//AUIGrid 생성 후 반환 ID
    var myGridID;
    
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        //Call Ajax
        fn_getStockListAjax();
        
        if(getParamForm.pstStusIdParam.value == '1'){
        	$("#editBtn").show();
        }else{
        	$("#editBtn").hide();
        }
      
    });
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
                dataField : "stkCodeDesc",
                headerText : '<spring:message code="sal.title.text.stockDescription" />',
                editable : false
            }, {
                dataField : "pstItmReqQty",
                headerText : '<spring:message code="sal.title.text.reqBrQuantity" />',
                width : 120,
                editable : false
            }, {
                dataField : "pstItmDoQty",
                headerText : '<spring:message code="sal.title.text.doQuantity" />',
                width : 120,
                editable : false
            }, {
                dataField : "pstItmCanQty",
                headerText : '<spring:message code="sal.title.text.cancelBrQuantity" />',
                width : 120,
                editable : false
            }, {
                dataField : "pstItmBalQty",
                headerText : '<spring:message code="sal.title.text.balanceBrQuantity" />',
                width : 120,
                editable : false
            }, {
            	dataField : "pstItmPrc",
                headerText : '<spring:message code="sal.title.itemPrice" />',
                dataType:"numeric", 
                formatString:"#,##0.00",
                width : 130,
                editable : false
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : true, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            showFooter : true  ,
            groupingMessage : "Here groupping"
        };
        
        //푸터 설정
        var footerObject = [{
                                    labelText : "Total :",
                                    positionField : "stkCodeDesc"
                                    },
                                    {
                                    dataField : "pstItmReqQty",
                                    positionField : "pstItmReqQty",
                                    operation : "SUM",
                                    formatString : "#,##0"
                                    },
                                    {
                                    labelText : "Total :",
                                    positionField : "pstItmBalQty"
                                    },
                                    {
                                    dataField : "pstItmPrc",
                                    positionField : "pstItmPrc",
                                    operation : "SUM",
                                    formatString : "#,##0.00"
                              }];
        
        myGridID = GridCommon.createAUIGrid("#stock_grid_wrap", columnLayout,"", gridPros);
        AUIGrid.setFooter(myGridID, footerObject); 
    }
    
    function fn_getStockListAjax(){
    	Common.ajax("GET", "/sales/pst/getPstStockJsonDetailPop",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
        AUIGrid.resize(gridName, 900, 250);
   }
    
    function fn_goEdit(){
    	fn_selectPstRequestDOListAjax();
    	Common.popupDiv('/sales/pst/getPstRequestDOEditPop.do', $('#getParamForm').serializeJSON(), null , true, '_editDiv2');
    	$("#autoClose").click();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.pstReqInfo" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="autoClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start --
<h2>AGENSI PERKERJAAN TALENT2 INTERNATIONAL SDN BHD</h2>
</aside>-- title_line end -->
<ul class="right_btns" id="editBtn">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_goEdit()"><spring:message code="sal.title.text.edit" /></a></p></li>
</ul>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.title.text.pstInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.pstMailAddress" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.pstDeliveryAddress" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.pstMailContact" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.pstDeliveryContact" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(myGridID)"><spring:message code="sal.title.text.pstStockList" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="pstSalesOrdId" name="pstSalesOrdId" value="${pstInfo.pstSalesOrdId}">
    <input type="hidden" id="pstStusIdParam" name="pstStusIdParam" value="${pstStusIdParam}">
    <input type="hidden" id="pstSalesOrdIdParam" name="pstSalesOrdIdParam" value="${pstSalesOrdIdParam}">
    <input type="hidden" id="pstDealerDelvryCntId" name="pstDealerDelvryCntId" value="${pstDealerDelvryCntId}">
    <input type="hidden" id="pstDealerMailCntId" name="pstDealerMailCntId" value="${pstDealerMailCntId}">
    <input type="hidden" id="pstDealerDelvryAddId" name="pstDealerDelvryAddId" value="${pstDealerDelvryAddId}">
    <input type="hidden" id="pstDealerMailAddId" name="pstDealerMailAddId" value="${pstDealerMailAddId}">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.psoId" /></th>
    <td><span>${pstInfo.pstSalesOrdId}</span></td>
    <th scope="row"><spring:message code="sal.title.text.psoRefNo" /></th>
    <td><span>${pstInfo.pstRefNo}</span></td>
    <th scope="row"><spring:message code="sal.title.text.customerPO" /></th>
    <td><span>${pstInfo.pstCustPo}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.currencyType" /></th>
    <td><span>${pstInfo.pstCurTypeCode}</span></td>
    <th scope="row"><spring:message code="sal.title.text.currencyRate" /></th>
    <td><span>${pstInfo.pstCurRate}</span></td>
    <th scope="row"><spring:message code="sal.title.text.personInCharge" /></th>
    <td><span>${pstInfo.picName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.psoStatus" /></th>
    <td><span>${pstInfo.pstStusCode}</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${pstInfo.crtUserName}</span></td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td><span>${pstInfo.crtDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="5"><span>${pstInfo.pstRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.title.text.mailingAddr" /></th>
    <td colspan="3"><span>${pstMailAddr.addrDtl}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${pstMailAddr.street}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${pstMailAddr.area}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${pstMailAddr.city}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${pstMailAddr.postcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${pstMailAddr.state}</span></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${pstMailAddr.country}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.title.text.deliveryAddress" /></th>
    <td colspan="3"><span>${pstDeliveryAddr.addrDtl}&nbsp;</span></td>
</tr>
<tr>
    <td colspan="3"><span>${pstDeliveryAddr.street}&nbsp;</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><span>${pstDeliveryAddr.area}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${pstDeliveryAddr.city}</span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span>${pstDeliveryAddr.postcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><span>${pstDeliveryAddr.state}</span></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><span>${pstDeliveryAddr.country}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${pstMailContact.cntName }</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${pstMailContact.dealerInitialCode }</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${pstMailContact.gender }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${pstMailContact.nric }</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${pstMailContact.raceName }</span></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span>${pstMailContact.telf }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span>${pstMailContact.telM1 }</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${pstMailContact.telR }</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${pstMailContact.telO }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${pstDeliveryContact.cntName }</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${pstDeliveryContact.dealerInitialCode }</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${pstDeliveryContact.gender }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${pstDeliveryContact.nric }</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${pstDeliveryContact.raceName }</span></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span>${pstDeliveryContact.telf }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span>${pstDeliveryContact.telM1 }</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${pstDeliveryContact.telR }</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${pstDeliveryContact.telO }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start 

<ul class="right_btns mt10">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>-->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="stock_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->