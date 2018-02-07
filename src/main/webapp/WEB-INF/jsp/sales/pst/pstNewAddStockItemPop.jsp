<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    doGetCombo('/common/selectCodeList.do', '11', '','addStockCate', 'S' , '');            // Category Combo Box
    
    function fn_getStockItem(obj, value , tag , selvalue){
        var type = stockItemForm.addStockType.value;
//        var robj= '#'+obj;
//        $(robj).attr("disabled",false);
        getCmbChargeNm('/sales/pst/getStockItemJsonList.do', type, value , selvalue,obj, 'S', '');
    }
    
    function getCmbChargeNm(url, typeCd ,codevalue ,  selCode, obj , type, callbackFn){
        $.ajax({
            type : "GET",
            url : url,
            data : { addStockType : typeCd , addStockCate : codevalue },
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
               var rData = data;
               doDefNmCombo(rData, selCode, obj , type,  callbackFn)
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
            }
        });
    }
    
    function doDefNmCombo(data, selCode, obj , type, callbackFn){
        var targetObj = document.getElementById(obj);

        if(data.length == 0){
        	Common.alert('<spring:message code="sal.alert.msg.noItemFound" />');
        	return;
        }
        
        for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
        }
        obj= '#'+obj;


        $.each(data, function(index,value) {

                $('<option />', {value : data[index].stkId, text:data[index].stkCodeDesc}).appendTo(obj);

        });


        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    }
    
    function fn_addStockItem(){

        var type = $("#addStockType").val();
        var category = $("#addStockCate").val();
        var stkId = $("#addStockItem").val();
        var item = $("#addStockItem option:selected").text();
        var qty = document.stockItemForm.addStockQty.value;
        var price = document.stockItemForm.addItemPrc.value;
        var totPrice = qty*price;
        
        if(type == "" && category == ""&& item == ""&& qty == ""&& price == ""){
            Common.alert('<spring:message code="sal.alert.msg.someReqFieldEmpty" />');
            return false;
        }
        
        if(item == ""){
        	Common.alert('<spring:message code="sal.alert.msg.someReqFieldEmpty" />');
            return false;
        }
        if(qty == ""){
            Common.alert('<spring:message code="sal.alert.msg.someReqFieldEmpty" />');
            return false;
        }
        if(price == ""){
            Common.alert('<spring:message code="sal.alert.msg.someReqFieldEmpty" />');
            return false;
        }
        
        fn_addStockItemInfo(type, category, item, qty, price, totPrice, stkId);
        $("#autoClose").click();
    }
    
    var prev = "";
    var regexp = /^\d*(\.\d{0,2})?$/;

    function fn_inputAmt(obj){
        
        if(obj.value.search(regexp) == -1){
            obj.value = prev;
        }else{
            prev = obj.value;
        }
        
        
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.addStockItem" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="autoClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form method="GET" id="stockItemForm" name="stockItemForm">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:110px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.type" /></th>
            <td>
                <select class="" id="addStockType" name="addStockType">
                    <option value=""><spring:message code="sal.combo.text.stockType" /></option>
                    <option value="61"><spring:message code="sal.combo.text.stock" /></option>
                    <option value="62"><spring:message code="sal.combo.text.filter" /></option>
                    <option value="63"><spring:message code="sal.combo.text.sparePart" /></option>
                    <option value="64"><spring:message code="sal.combo.text.miscellaneous" /></option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.category" /></th>
            <td>
                <select class="" id="addStockCate" name="addStockCate" onChange="fn_getStockItem('addStockItem', this.value, '', '')">
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.stockItem" /><span class="must">*</span></th>
            <td>
                <select class="w100p" id="addStockItem" name="addStockItem">
                </select>
                </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.quantity" /><span class="must">*</span></th>
            <td><input type="text" id="addStockQty" name="addStockQty" onkeyup="fn_inputAmt(this)" title="" placeholder="" class="" /></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.unitPrice" /><span class="must">*</span></th>
            <td><input type="text" id="addItemPrc" name="addItemPrc" onkeyup="fn_inputAmt(this)" title="" placeholder="" class="" /></td>
        </tr>
    </tbody>
    </table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_addStockItem()"><spring:message code="sal.title.text.addItm" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
