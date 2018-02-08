<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var optionUnit = { 
isShowChoose: true,
//type : 'M'
};

    //AUIGrid 생성 후 반환 ID
    var myStkGridID;
    var totUnitVal = 0;
    var totAmountVal = 0;
    
    $(document).ready(function(){

        //Call Ajax
//      fn_getDealerListAjax();
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        CommonCombo.make("cmbPstIncharge", "/sales/pst/getInchargeList", '', $("#userId").val(), {
            id: "codeId",
            name: "codeName",
            type:"S"
        });//Incharge Person
        doGetCombo('/common/selectCodeList.do', '357', '','cmbNewDealerType', 'S' , '');     // Dealer Type Combo Box
        
        if(insertForm.dealerTypeFlag.value == "REQ"){
        	CommonCombo.make("cmbLocation", "/common/selectCodeList.do", {groupCode:'361'}, "", {
                id: "code",
                name: "codeName",
                type:"S"
            });     // WH LOC Combo Box
        }else{
        	CommonCombo.make("cmbLocation", "/common/selectCodeList.do", {groupCode:'362'}, "", {
                id: "code",
                name: "codeName",
                type:"S"
            });     // WH LOC Combo Box
        }
        
        
//        fn_dealerToDealer('2575');
    });

    
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
                dataField : "pstItmStkDesc",
                headerText : '<spring:message code="sal.title.text.stockDescription" />',
                editable : false
            }, {
                dataField : "pstItmPrc",
                headerText : '<spring:message code="sal.title.unitPrice" />',
                width : 110,
                editable : false
            }, {
                dataField : "pstItmReqQty",
                headerText : '<spring:message code="sal.text.quantity" />',
                width : 110,
                editable : false
            }, {
                dataField : "pstItmTotPrc",
                headerText : '<spring:message code="sal.title.text.itemTotPrice" />',
                width : 170,
                editable : false
            }, {
                dataField : "pstItmStkId",
                visible : false
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
//            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : true, //checkBox
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
        };
        
        myStkGridID = GridCommon.createAUIGrid("#addStock_grid_wrap", columnLayout, '', gridPros);
        
    }
    
    function fn_dealerInfo(){

        insertForm.dealerId.value = insertForm.cmbDealer.value;
        
        Common.ajax("GET", "/sales/pst/dealerInfo.do", $("#insertForm").serializeJSON(), function(result) {
            $("#dealerEmail").val(result.dealerEmail);
            $("#dealerNric").val(result.dealerNric);
            $("#dealerBrnchId").val(result.dealerBrnchId);
            $("#brnchId").val(result.brnchId);
            $("#mailDealerAddId").val(result.dealerAddId);
            $("#mailAddrAreaId").val(result.areaId);
            $("#newMailaddrDtl").val(result.addrDtl);
            $("#newMailstreet").val(result.street);
            $("#newMailarea").val(result.area);
            $("#newMailcity").val(result.city);
            $("#newMailpostcode").val(result.postcode);
            $("#newMailstate").val(result.state);
            $("#newMailcountry").val(result.country);
            
            $("#delvryDealerAddId").val(result.dealerAddId);
            $("#delvryAddrAreaId").val(result.areaId);
            $("#newDelvryaddrDtl").val(result.addrDtl);
            $("#newDelvrystreet").val(result.street);
            $("#newDelvryarea").val(result.area);
            $("#newDelvrycity").val(result.city);
            $("#newDelvrypostcode").val(result.postcode);
            $("#newDelvrystate").val(result.state);
            $("#newDelvrycountry").val(result.country);
            
            $("#mailDealerCntId").val(result.dealerCntId);
            $("#newMailContCntName").val(result.cntName);
            $("#newMailContDealerIniCd").val(result.dealerIniCd);
            $("#newMailContGender").val(result.gender);
            $("#newMailContNric").val(result.nric);
            $("#newMailContRaceName").val(result.raceName);
            $("#newMailContTelF").val(result.telf);
            $("#newMailContTelM1").val(result.telM1);
            $("#newMailContTelR").val(result.telR);
            $("#newMailContTelO").val(result.telO);
            
            $("#delvryDealerCntId").val(result.dealerCntId);
            $("#newDelvryContCntName").val(result.cntName);
            $("#newDelvryContDealerIniCd").val(result.dealerIniCd);
            $("#newDelvryContGender").val(result.gender);
            $("#newDelvryContNric").val(result.nric);
            $("#newDelvryContRaceName").val(result.raceName);
            $("#newDelvryContTelF").val(result.telf);
            $("#newDelvryContTelM1").val(result.telM1);
            $("#newDelvryContTelR").val(result.telR);
            $("#newDelvryContTelO").val(result.telO);
            
            doGetCombo('/sales/pst/pstNewCmbDealerBrnchList', result.dealerBrnchId, result.brnchId,'cmbPstBranch', 'S' , ''); //Incharge Person
            
            console.log("data : " + result);
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
          }
          catch (e) {
              console.log(e);
              Common.alert('<spring:message code="sal.alert.msg.liarDataSrchFailed" />');
          }

          alert("Fail : " + jqXHR.responseJSON.message);          
      });
    }
    
    function fn_addStockItemPop(){
        Common.popupDiv("/sales/pst/addStockItempPop.do", $("#insertForm").serialize(), null , true, '_stockItemDiv');
    }
    
    function fn_addStockItemInfo(type, category, stkItem, qty, price, totPrice, stkId){
        
        for(var j = 0; j < AUIGrid.getRowCount(myStkGridID); j++) {                    
            if(stkId == AUIGrid.getCellValue(myStkGridID, j, "pstItmStkId")) {
                Common.alert('<spring:message code="sal.title.text.thisStokItmisExist" />');
                return false;
            }
        }
        
        var item = new Object();
            item.pstItmStkId = stkId;
            item.pstItmStkDesc = stkItem;
//            item.bank = category;
            item.pstItmPrc = price;
            item.pstItmReqQty = qty;
            item.pstItmTotPrc = totPrice;
/*
            totUnitVal = totUnitVal + Number(qty);
            totAmountVal = totAmountVal + Number(totPrice);
            
            $("#totUnit").val(totUnitVal);
            $("#totAmount").val(totAmountVal);
*/
            AUIGrid.addRow(myStkGridID, item, "last"); 

            calcTotal();
    }
    
    // save
    function fn_saveNewPstRequest(){
    	if(insertForm.cmbDealer.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelectADealer" />');
            return false;
        }
    	if(insertForm.pstNewCustPo.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyTheCustPo" />');
            return false;
        }
    	if(insertForm.cmbPstIncharge.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelPersonInCharge" />');
            return false;
        }
    	if(insertForm.cmbLocation.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelWhLocation" />');
            return false;
        }
//    	if(insertForm.totUnit.value == ""){
//            Common.alert("* Please select Delivery Stock.");
//            return false;
//        }
    	
            var pstRequestDOForm = {
                dataSet     : GridCommon.getGridData(myStkGridID),
                pstSalesMVO : {
                    // info
//                    cmbNewDealerType : insertForm.cmbNewDealerType.value,
                    pstDealerId : insertForm.cmbDealer.value,
                    pstType : insertForm.pstType.value,
                    pstLocId : insertForm.cmbLocation.value,
//                  dealerEmail : insertForm.dealerEmail.value,  //안씀
//                  cmbPstBranch : insertForm.cmbPstBranch.value,
//                  dealerNric : insertForm.dealerNric.value,
                    pic : insertForm.cmbPstIncharge.value,
                    pstCustPo : insertForm.pstNewCustPo.value,
                    pstRem : insertForm.pstNewRem.value,
                    pstCurRate : $("#curRate").val(),
                    pstCurTypeId : $("#curTypeCd").val(),
                    pstTotAmt : $("#totAmount").val(),
                    // Mailing Address
                    pstDealerMailAddId :$("#mailDealerAddId").val(),
//보류                    newMailaddrDtl : insertForm.newMailaddrDtl.value,
//보류                    newMailstreet : insertForm.newMailstreet.value,
//보류                    mailAddrAreaId : insertForm.mailAddrAreaId.value,
                    // Delivery Address
                    pstDealerDelvryAddId : $("#delvryDealerAddId").val(),
//보류                    newDelvryaddrDtl : insertForm.newDelvryaddrDtl.value,
//보류                    newDelvrystreet : insertForm.newDelvrystreet.value,
//보류                    delvryAddrAreaId : insertForm.delvryAddrAreaId.value,
                    // Mailing Contact Person
                    pstDealerMailCntId : $("#mailDealerCntId").val(),
//                    ext : insertForm.newMailContCntName.value,
//                    rem : insertForm.newMailContDealerIniCd.value,
//                    ext : insertForm.newMailContGender.value,
//                    rem : insertForm.newMailContNric.value,
//                    rem : insertForm.newMailContRaceName.value,
//                    telM : insertForm.newMailContTelM1.value,
//                    telR : insertForm.newMailContTelR.value,
//                    telF : insertForm.newMailContTelO.value,
//                    telO : insertForm.newMailContTelF.value
                    // Delivery Contact Person 해야함.
                    pstDealerDelvryCntId : $("#delvryDealerCntId").val()
                }
            };
            
            Common.ajax("POST", "/sales/pst/insertNewRequestDO.do", pstRequestDOForm, function(result) {
                Common.alert('<spring:message code="sal.alert.msg.savePstReqDo" />', fn_success);

            }, function(jqXHR, textStatus, errorThrown) {
                Common.alert("실패하였습니다.");
                console.log("실패하였습니다.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
                
                alert(jqXHR.responseJSON.message);
                console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
                
            });
        
    }
    
    function fn_itemDel() {
        AUIGrid.removeCheckedRows(myStkGridID);        
        calcTotal();
    }
    
    function calcTotal() {        
        var totQty = 0;
        var totPrc = 0;
        
        for(var j = 0; j < AUIGrid.getRowCount(myStkGridID); j++) {                    
            totQty += Number(AUIGrid.getCellValue(myStkGridID, j, "pstItmReqQty"));
            totPrc += Number(AUIGrid.getCellValue(myStkGridID, j, "pstItmTotPrc"));
        }
        
        $("#totUnit").val(totQty);
        $("#totAmount").val(totPrc);
    }
    
    function fn_success(){
    	$("#newPopClose").click();
    	fn_selectPstRequestDOListAjax();
    }
    
    function fn_getRate() {
        if($("#curTypeCd").val() == 1148){
        	$("#curRate").val($("#insRate").val());
        }else if($("#curTypeCd").val() == 1150){
        	$("#curRate").val('1.00');
        }else if($("#curTypeCd").val() == 1149){
        	$("#curRate").val('1.00');
        }
    }
    
    function fn_dealerToDealer(str){


        if(str == 0){
//          $("input:select[name='cmbPstType']").prop("checked", false);
//            $("input:select[name='cmbPstType']").attr("disabled" , "disabled");
            return false;
        }
        if(insertForm.dealerTypeFlag.value == "REQ"){
        	if(str == 2575){
        		insertForm.pstType.value = 2577;
//        		$("#cmbNewDealerType").val(2577);
//        		alert($("#cmbNewDealerType").val());
        	}else if(str == 2576){
        		insertForm.pstType.value = 2579;
        	}else{
        		Common.alert('<spring:message code="sal.alert.msg.plzChkGeneralCode" />');
        	}
        }else{
        	if(str== 2575){
                insertForm.pstType.value = 2578;
            }else if(str== 2576){
                insertForm.pstType.value = 2580;
            }else{
                Common.alert('<spring:message code="sal.alert.msg.plzChkGeneralCode" />');
            }
        }
//      alert($("#cmbNewDealerType").val());
//      doGetCombo('/common/selectCodeList.do', '358', $("#cmbDealerType").val(),'cmbPstType', 'M' , '');         // PST Type Combo Box
//      CommonCombo.make('cmbPstType', '/common/selectCodeList.do', {codeId : $("#cmbDealerType").val()} , '', {type: 'M'});
        CommonCombo.make("cmbDealer", "/sales/pst/pstNewDealerInfo.do", {cmbNewDealerType : $("#cmbNewDealerType").val()} , '' , optionUnit); //Status
    }
    
    function chgTab() {
        AUIGrid.resize(myStkGridID, 950, 300);
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.newPstSales" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="newPopClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num3">
    <li><a href="#" class="on"><spring:message code="sal.title.text.particInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.mailingAddr" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.deliveryAddress" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.mailingCntcPerson" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.deliveryCntcPerson" /></a></li>
    <li><a href="#" onclick="javascript:chgTab();"><spring:message code="sal.title.text.salesOrder" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="insertForm" name="insertForm" method="post">
    <input type="hidden" id="dealerId" name="dealerId">
    <input type="hidden" id="dealerBrnchId" name="dealerBrnchId">
    <input type="hidden" id="brnchId" name="brnchId">
    <input type="hidden" id="insRate" name="insRate" value="${getRate.rate}">
    <input type="hidden" id="dealerTypeFlag" name="dealerTypeFlag" value="${dealerTypeFlag}">
    <input type="hidden" id="pstType" name="pstType">
    <input type="hidden" id="userId" name="userId" value="${userId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dealerType" /><span class="must">*</span></th>
    <td>
        <select class="select w100p" id="cmbNewDealerType" name="cmbNewDealerType" onchange="fn_dealerToDealer(this.value)"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.dealer" /><span class="must">*</span></th>
    <td>
        <select class="w100p" id="cmbDealer" name="cmbDealer" onchange="fn_dealerInfo()">
<!--             <option value="">Dealer</option>
           <c:forEach var="list" items="${dealerCmbList }">
               <option value="${list.dealerId}">${list.dealerName}</option>
           </c:forEach>
 -->
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.branch" /></th>
    <td>
        <select class="w100p" id="cmbPstBranch" name="cmbPstBranch" disabled="disabled">
        </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.whLoc" /></th>
    <td>
        <select class="w100p" id="cmbLocation" name="cmbLocation">
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.personInCharge" /><span class="must">*</span></th>
    <td>
        <select class="w100p" id="cmbPstIncharge" name="cmbPstIncharge">
        </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td><input type="text" id="dealerNric" name="dealerNric" title="" placeholder="NRIC/Company Number" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input type="text" id="dealerEmail" name="dealerEmail" title="" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row"><spring:message code="sal.title.text.customerPO" /><span class="must">*</span></th>
    <td><input type="text" id="pstNewCustPo" name="pstNewCustPo" title="" placeholder="Customer PO" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="3"><textarea cols="20" rows="5" id="pstNewRem" name="pstNewRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<input type="hidden" id="mailAddrAreaId" name="mailAddrAreaId">
<input type="hidden" id="mailDealerAddId" name="mailDealerAddId">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.title.text.mailingAddr" /><span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newMailaddrDtl" name="newMailaddrDtl" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newMailstreet" name="newMailstreet" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><input type="text" id="newMailarea" name="newMailarea" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span><input type="text" id="newMailcity" name="newMailcity" title="" placeholder="" readonly class="w100p readonly" /></span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span><input type="text" id="newMailpostcode" name="newMailpostcode" title="" placeholder="" readonly class="w100p readonly" /></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><input type="text" title="" id="newMailstate" name="newMailstate" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><input type="text" title="" id="newMailcountry" name="newMailcountry" placeholder="" readonly class="w100p readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<input type="hidden" id="delvryAddrAreaId" name="delvryAddrAreaId">
<input type="hidden" id="delvryDealerAddId" name="delvryDealerAddId">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.title.text.deliveryAddress" /><span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newDelvryaddrDtl" name="newDelvryaddrDtl" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newDelvrystreet" name="newDelvrystreet" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area" /></th>
    <td colspan="3"><input type="text" id="newDelvryarea" name="newDelvryarea" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span><input type="text" id="newDelvrycity" name="newDelvrycity" title="" placeholder="" readonly class="w100p readonly" /></span></td>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
    <td><span><input type="text" id="newDelvrypostcode" name="newDelvrypostcode" title="" placeholder="" readonly class="w100p readonly" /></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td><input type="text" id="newDelvrystate" name="newDelvrystate" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td><input type="text" id="newDelvrycountry" name="newDelvrycountry" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<input type="hidden" id="mailDealerCntId" name="mailDealerCntId">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td><input type="text" id="newMailContCntName" name="newMailContCntName" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><input type="text" id="newMailContDealerIniCd" name="newMailContDealerIniCd" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input type="text" id="newMailContGender" name="newMailContGender" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" id="newMailContNric" name="newMailContNric" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input type="text" id="newMailContRaceName" name="newMailContRaceName" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><input type="text" id="newMailContTelM1" name="newMailContTelM1" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><input type="text" id="newMailContTelR" name="newMailContTelR" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><input type="text" id="newMailContTelO" name="newMailContTelO" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><input type="text" id="newMailContTelF" name="newMailContTelF" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<input type="hidden" id="delvryDealerCntId" name="delvryDealerCntId">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td><input type="text" id="newDelvryContCntName" name="newDelvryContCntName" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><input type="text" id="newDelvryContDealerIniCd" name="newDelvryContDealerIniCd" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><input type="text" id="newDelvryContGender" name="newDelvryContGender" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" id="newDelvryContNric" name="newDelvryContNric" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><input type="text" id="newDelvryContRaceName" name="newDelvryContRaceName" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><input type="text" id="newDelvryContTelM1" name="newDelvryContTelM1" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><input type="text" id="newDelvryContTelR" name="newDelvryContTelR" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><input type="text" id="newDelvryContTelO" name="newDelvryContTelO" title="" placeholder="" readonly class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><input type="text" id="newDelvryContTelF" name="newDelvryContTelF" title="" placeholder="" readonly class="w100p readonly" /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.stockItmRequest" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.currency" /></th>
    <td>
    <select id="curTypeCd" name="curTypeCd" onchange="fn_getRate()">
        <option value="1150"><spring:message code="sal.combo.text.myr" /></option>
        <option value="1149"><spring:message code="sal.combo.text.sgd" /></option>
        <option value="1148"><spring:message code="sal.combo.text.usd" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.currencyRate" /></th>
    <td><input type="text" id="curRate" name="curRate" value="1.00" title="" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.totalUnit" /></th>
    <td><input type="text" id="totUnit" name="totUnit"  title="" placeholder="" class="" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.totAmt" /></th>
    <td><input type="text" id="totAmount" name="totAmount" title="" placeholder="" class="" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="left_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_addStockItemPop()"><spring:message code="sal.title.text.addStockItem" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_itemDel()"><spring:message code="sal.title.text.deleteStockItm" /></a></p></li>
</ul>

<section class="search_result"><!-- search_result start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="addStock_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="fn_saveNewPstRequest()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->