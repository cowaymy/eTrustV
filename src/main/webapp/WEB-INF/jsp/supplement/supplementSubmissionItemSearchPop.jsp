<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>
<script type="text/javascript">

//Grid 생성 후 반환 ID
var basketGridID;

var ItmOption = {
        type: "M",
        isCheckAll: false
};


$(document).ready(function() {

    //Create Grid
    fn_createBasketGrid(); //basket

    //Init
    fn_initField();



    var itmType = {itemType : 54};
    CommonCombo.make('_purcItems', "/supplement/selectSupplementItmList", itmType , '', ItmOption);


    $("#_basketAdd").click(function() {

        //Validation
        //Null check
        if($("#_purcItems").val() == null || $("#_purcItems").val() == ''){
            Common.alert("No Selected Items.");
            return;
        }

        //Check Duplication of Basket , ItemList
        var basketCodeArray = AUIGrid.getColumnValues(basketGridID, 'stkId');
        var values = $("#_purcItems").val();
        var msg = '';
        for (var idx = 0; idx < basketCodeArray.length; idx++) {
            for (var i = 0; i < values.length; i++) {

                //console.log("basketCodeArray[idx] : " + basketCodeArray[idx]);
                //console.log("values[i] : " + values[i]);

                if(basketCodeArray[idx] == values[i]){
                    msg += $("#_purcItems").find("option[value='"+values[i]+"']").text();
                    Common.alert("* " + msg +'<spring:message code="sal.alert.msg.isExistInList" />');
                    return;
                }
            }
        }

            Common.ajax('GET', '/supplement/chkSupplementStockList', $("#_itemSrcForm").serialize(), function(result) {

                for (var i = 0; i < result.length; i++) {
                   var calResult = fn_calculateAmt(result[i].amt, 1);
                   result[i].subTotal  = calResult.subTotal;
                   result[i].subChanges = calResult.subChanges;
                   result[i].taxes  = calResult.taxes;
                   result[i].inputQty = 1;
               }

                AUIGrid.addRow(basketGridID, result, 'last');

            });


    });

    //Delete Low
    $("#_chkDelBtn").click(function() {

        AUIGrid.removeCheckedRows(basketGridID);

    });


    //Save
    $("#_itemSrchSaveBtn").click(function() {
        //Validation
        //1 .장바구니 물품 Null Check
        var valChk = true;
        var nullChkNo = AUIGrid.getRowCount(basketGridID);
    //  console.log(' nullChkNo(row 개수) : ' + nullChkNo);
        if(nullChkNo == null || nullChkNo < 1){
            Common.alert('<spring:message code="sal.alert.msg.selectItm" />');
            return;
        }
        //2. 장바구니 수량 중  0 이 있는지 체크
        var ivenChkArr = AUIGrid.getColumnValues(basketGridID, 'qty');
        $(ivenChkArr).each(function(idx, el) {
            if(ivenChkArr[idx] == 0){
                valChk = false;
                return false;
            }
        });
        if( valChk == false){
            Common.alert('<spring:message code="sal.alert.msg.listNoInvItm" />');
            return;
        }

        var qtyChkArr = AUIGrid.getColumnValues(basketGridID, 'inputQty'); //input Quantity
        $(qtyChkArr).each(function(idx, el) {
            if(qtyChkArr[idx] == 0){
                valChk = false;
                return false;
            }
        });
        if(valChk == false){
            Common.alert('<spring:message code="sal.alert.msg.keyInQty" />');
            return;
        }
        //5. inventory 수량 보다 입력한 수량값이 넘는지 체크
        if(ivenChkArr.length == qtyChkArr.length){
            $(ivenChkArr).each(function(idx , el) {
                //console.log('인벤토리 : '  +  ivenChkArr[idx] + ' , 구입수량 : ' + qtyChkArr[idx] + ' , el : ' + el);
                if(ivenChkArr[idx] < qtyChkArr[idx]){
                    valChk = false;
                    return false;
                }
            });
            if(valChk == false){
                Common.alert('<spring:message code="sal.alert.msg.shortOfVol" />');
                return;
            }
        }else{
            Common.alert('<spring:message code="sal.alert.msg.failedToNewItm" />');
            return;
        }
        //6. 장바구니 리스트 중에 필터가 있을 경우  stkTypeId == 62
        var typeArr = AUIGrid.getColumnValues(basketGridID, 'stkTypeId'); //Type Chk
        var filterChkFlag = false;

        $(typeArr).each(function(idx, el) {
            if(typeArr[idx] == 62){ //filter
                filterChkFlag = true;
                return false;
            }
        });

        //Vaidaton Success
        var finalPurchGridData = AUIGrid.getGridData(basketGridID);
        /* console.log(" finalPurchGridData : " + finalPurchGridData);
        console.log(" finalPurchGridData[0] : " + finalPurchGridData[0]);
        console.log(" finalPurchGridData[0].stkCode : " + finalPurchGridData[0].stkCode); */
        //setGrid for Purchase
        getItemListFromSrchPop(finalPurchGridData);
        $("#_itmSrchPopClose").click();

    });

});//Doc Ready Func End

function fn_createBasketGrid(){

     var basketColumnLayout =  [
                                {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '15%' , editable : false},
                                {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%', editable : false},
                                {dataField : "qty", headerText : '<spring:message code="sal.title.inventory" />', width : '10%', editable : false , visible :false},
                                {dataField : "inputQty", headerText : '<spring:message code="sal.title.qty" />', width : '10%', editable : true, dataType : "numeric"},
                                {dataField : "amt", headerText :'<spring:message code="sal.title.unitPrice" />', width : '10%', dataType : "numeric", formatString : "#,##0.00",editRenderer : {
                                    type : "InputEditRenderer",
                                    onlyNumeric : true,
                                    allowPoint : true
                                }},
                                {dataField : "subChanges", headerText : '<spring:message code="sal.text.totAmt" />', width : '15%', editable : false , dataType : "numeric", formatString : "#,##0.00",expFunction : function(  rowIndex, columnIndex, item, dataField ) {
                                    var subObj = fn_calculateAmt(item.amt , item.inputQty);
                                    return Number(subObj.subChanges);
                                }},
                                {dataField : "taxes", headerText : 'GST(0%)', width : '15%', editable : false , visible :false , dataType : "numeric", formatString : "#,##0.00", expFunction : function(  rowIndex, columnIndex, item, dataField ) {
                                    var subObj = fn_calculateAmt(item.amt , item.inputQty);
                                    return Number(subObj.taxes);
                                }},
                                {dataField : "stkTypeId" , visible :false},
                                {dataField : "serialChk" , visible :false}, ////SERIAL_CHK
                                {dataField : "stkId" , visible :false}//STK_ID
                               ];

        //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                fixedColumnCount    : 1,
                showStateColumn     : false,
                displayTreeOpen     : false,
       //         selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                softRemoveRowMode : false,
                showRowCheckColumn : true
        };

        basketGridID = GridCommon.createAUIGrid("#basket_grid_wrap", basketColumnLayout,'', gridPros);
        AUIGrid.resize(basketGridID , 960, 300);

}

function fn_initField(){


}


//조회조건 combo box
function f_multiCombo(){
    $(function() {
        $('#_purcItems').change(function() {

        }).multipleSelect({
            selectAll: false, // 전체선택
            width: '80%'
        });
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<!-- get Values from Controller -->
<%-- <input type="hidden" id="_whBrnchId" value="${whBrnchId}"> --%>

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="supplement.text.itemSelection" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<%-- <ul class="right_btns">
    <li><p class="btn_blue"><a id="_basketAdd"><spring:message code="sal.btn.add" /></a></p></li>
</ul> --%>

<form id="_itemSrcForm">

<input type="hidden" id="_locId" name="locId" value="${whBrnchId}">

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.item" /></th>
    <td colspan="4">
    <select class="w100p" id="_purcItems" name="itmLists"></select>
    </td>
</tr>

</tbody>
</table><!-- table end -->

</form>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.purchItems" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="_basketAdd"><spring:message code="sal.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a id="_chkDelBtn"><spring:message code="sal.btn.del" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="basket_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<div id="_gridArea">


</div>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_itemSrchSaveBtn"><spring:message code="sal.btn.save2" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->