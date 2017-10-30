<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var myStkGridID;
    var totUnitVal = 0;
    var totAmountVal = 0;
    
    $(document).ready(function(){
        
        //Call Ajax
//      fn_getDealerListAjax();
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        doGetCombo('/sales/pst/getInchargeList', '', '','cmbPstIncharge', 'S' , ''); //Incharge Person

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
                dataField : "pstItmStkDesc",
                headerText : "Stock Description",
                editable : false
            }, {
                dataField : "pstItmPrc",
                headerText : "Item Price",
                width : 110,
                editable : false
            }, {
                dataField : "pstItmReqQty",
                headerText : "Quantity",
                width : 110,
                editable : false
            }, {
                dataField : "pstItmTotPrc",
                headerText : "Item Total Price",
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
            selectionMode       : "singleRow",  //"multipleCells",            
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
              Common.alert("Liar data search failed.");
          }

          alert("Fail : " + jqXHR.responseJSON.message);          
      });
    }
    
    function fn_addStockItemPop(){
        Common.popupDiv("/sales/pst/addStockItempPop.do", $("#insertForm").serialize(), null , true, '_stockItemDiv');
    }
    
    function fn_addStockItemInfo(type, category, stkItem, qty, price, totPrice, stkId){
        
        var item = new Object();
            item.pstItmStkId = stkId;
            item.pstItmStkDesc = stkItem;
//            item.bank = category;
            item.pstItmPrc = price;
            item.pstItmReqQty = qty;
            item.pstItmTotPrc = totPrice;
            
            totUnitVal = totUnitVal + Number(qty);
            totAmountVal = totAmountVal + Number(totPrice);
            
            $("#totUnit").val(totUnitVal);
            $("#totAmount").val(totAmountVal);
            
            AUIGrid.addRow(myStkGridID, item, "last"); 
    }
    
    // save
    function fn_saveNewPstRequest(){
    	if(insertForm.cmbDealer.value == ""){
            Common.alert("* Please select a dealer.");
            return false;
        }
    	if(insertForm.pstNewCustPo.value == ""){
            Common.alert("* Please key the customer PO.");
            return false;
        }
    	if(insertForm.cmbPstIncharge.value == ""){
            Common.alert("* Please select person in charge.");
            return false;
        }
    	if(insertForm.totUnit.value == ""){
            Common.alert("* Please select Delivery Stock.");
            return false;
        }
    	
            var pstRequestDOForm = {
                dataSet     : GridCommon.getGridData(myStkGridID),
                pstSalesMVO : {
                    // info
                    pstDealerId : insertForm.cmbDealer.value,
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
                Common.alert("Save PST Request Do", fn_success);

            }, function(jqXHR, textStatus, errorThrown) {
                Common.alert("실패하였습니다.");
                console.log("실패하였습니다.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
                
                alert(jqXHR.responseJSON.message);
                console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
                
            });
        
    }
    
    function fn_itemDel(){
    	AUIGrid.removeCheckedRows(myStkGridID);
    }
    
    function fn_success(){
    	$("#newPopClose").click();
    }
    
    function fn_getRate() {
        if($("#curTypeCd").val() == 1148){
        	$("#curRate").val($("#insRate").val());
        }else if($("#curTypeCd").val() == 1150){
        	$("#curRate").val('1.00');
        }else if($("#curTypeCd").val() == 1149){
        	$("#curRate").val('');
        }
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New PST Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="newPopClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num3">
    <li><a href="#" class="on">Particular Information</a></li>
    <li><a href="#">Mailing Address</a></li>
    <li><a href="#">Delivery Address</a></li>
    <li><a href="#">Mailing Contact Person</a></li>
    <li><a href="#">Delivery Contact Person</a></li>
    <li><a href="#">Delivery Stock</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="insertForm" name="insertForm" method="post">
    <input type="hidden" id="dealerId" name="dealerId">
    <input type="hidden" id="dealerBrnchId" name="dealerBrnchId">
    <input type="hidden" id="brnchId" name="brnchId">
    <input type="hidden" id="insRate" name="insRate" value="${getRate.rate}">
    
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
    <th scope="row">Dealer<span class="must">*</span></th>
    <td>
        <select class="w100p" id="cmbDealer" name="cmbDealer" onchange="fn_dealerInfo()">
           <option value="">Dealer</option>
           <c:forEach var="list" items="${cmbDealerList }">
               <option value="${list.dealerId}">${list.dealerName}</option>
           </c:forEach>
        </select>
    </td>
    <th scope="row">Email</th>
    <td><input type="text" id="dealerEmail" name="dealerEmail" title="" placeholder="Email Address" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
        <select class="w100p" id="cmbPstBranch" name="cmbPstBranch" disabled="disabled">
        </select>
    </td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" id="dealerNric" name="dealerNric" title="" placeholder="NRIC/Company Number" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Person In Charge<span class="must">*</span></th>
    <td>
        <select class="w100p" id="cmbPstIncharge" name="cmbPstIncharge">
        </select>
    </td>
    <th scope="row">Customer PO</th>
    <td><input type="text" id="pstNewCustPo" name="pstNewCustPo" title="" placeholder="Customer PO" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Remark</th>
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
    <th scope="row" rowspan="2">Mailing Address<span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newMailaddrDtl" name="newMailaddrDtl" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newMailstreet" name="newMailstreet" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><input type="text" id="newMailarea" name="newMailarea" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span><input type="text" id="newMailcity" name="newMailcity" title="" placeholder="" class="w100p" /></span></td>
    <th scope="row">Postcode</th>
    <td><span><input type="text" id="newMailpostcode" name="newMailpostcode" title="" placeholder="" class="w100p" /></span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input type="text" title="" id="newMailstate" name="newMailstate" placeholder="" class="w100p" /></td>
    <th scope="row">Country</th>
    <td><input type="text" title="" id="newMailcountry" name="newMailcountry" placeholder="" class="w100p" /></td>
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
    <th scope="row" rowspan="2">Delivery Address<span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newDelvryaddrDtl" name="newDelvryaddrDtl" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newDelvrystreet" name="newDelvrystreet" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><input type="text" id="newDelvryarea" name="newDelvryarea" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span><input type="text" id="newDelvrycity" name="newDelvrycity" title="" placeholder="" class="w100p" /></span></td>
    <th scope="row">Postcode</th>
    <td><span><input type="text" id="newDelvrypostcode" name="newDelvrypostcode" title="" placeholder="" class="w100p" /></span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input type="text" id="newDelvrystate" name="newDelvrystate" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Country</th>
    <td><input type="text" id="newDelvrycountry" name="newDelvrycountry" title="" placeholder="" class="w100p" /></td>
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
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" id="newMailContCntName" name="newMailContCntName" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Initial</th>
    <td><input type="text" id="newMailContDealerIniCd" name="newMailContDealerIniCd" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Gender</th>
    <td><input type="text" id="newMailContGender" name="newMailContGender" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input type="text" id="newMailContNric" name="newMailContNric" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Race</th>
    <td><input type="text" id="newMailContRaceName" name="newMailContRaceName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input type="text" id="newMailContTelM1" name="newMailContTelM1" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input type="text" id="newMailContTelR" name="newMailContTelR" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Office)</th>
    <td><input type="text" id="newMailContTelO" name="newMailContTelO" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input type="text" id="newMailContTelF" name="newMailContTelF" title="" placeholder="" class="w100p" /></td>
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
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" id="newDelvryContCntName" name="newDelvryContCntName" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Initial</th>
    <td><input type="text" id="newDelvryContDealerIniCd" name="newDelvryContDealerIniCd" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Gender</th>
    <td><input type="text" id="newDelvryContGender" name="newDelvryContGender" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input type="text" id="newDelvryContNric" name="newDelvryContNric" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Race</th>
    <td><input type="text" id="newDelvryContRaceName" name="newDelvryContRaceName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input type="text" id="newDelvryContTelM1" name="newDelvryContTelM1" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input type="text" id="newDelvryContTelR" name="newDelvryContTelR" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Office)</th>
    <td><input type="text" id="newDelvryContTelO" name="newDelvryContTelO" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input type="text" id="newDelvryContTelF" name="newDelvryContTelF" title="" placeholder="" class="w100p" /></td>
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
<h2>Stock Item Request</h2>
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
    <th scope="row">Currency</th>
    <td>
    <select id="curTypeCd" name="curTypeCd" onchange="fn_getRate()">
        <option value="1150">MYR</option>
        <option value="1149">SGD</option>
        <option value="1148">USD</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Currency Rate</th>
    <td><input type="text" id="curRate" name="curRate" value="1.00" title="" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row">Total Unit</th>
    <td><input type="text" id="totUnit" name="totUnit"  title="" placeholder="" class="" readOnly/></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><input type="text" id="totAmount" name="totAmount" title="" placeholder="" class="" readOnly/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="left_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_addStockItemPop()">Add Stock Item</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_itemDel()">Delete Stock Item</a></p></li>
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
    <li><p class="btn_blue2"><a href="#" onclick="fn_saveNewPstRequest()">Save PST Request</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->