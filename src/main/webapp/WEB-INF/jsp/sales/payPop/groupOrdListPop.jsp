<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">

var  groupListGridID;
var ordNo = "${ordNo}";

//AUIGrid 칼럼 설정
var columnLayout = [
    {
        dataField : "isMain",
        headerText : "<spring:message code='pay.head.mainOrder'/>",
        editable : true,
        visible:true,
        renderer :
        {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : 1, // true, false 인 경우가 기본
            unCheckValue : 0,
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

            }

        }
    }, {
        dataField : "custId",
        headerText : "<spring:message code='pay.head.customerId'/>",
        editable : false
    }, {
        dataField : "salesOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false,
    },{
        dataField : "salesDt",
        headerText : "<spring:message code='pay.head.orderDate'/>",
        editable : false,
    },{
        dataField : "code",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
    },{
        dataField : "product",
        headerText : "<spring:message code='pay.head.product'/>",
        editable : false,
        width: 250
    },{
        dataField : "mthRentAmt",
        headerText : "<spring:message code='pay.head.rentalFees'/>",
        editable : false
    }];

var gridPros = {
        editable : false,
        showStateColumn : false,
        selectionMode : "singleRow"

};

$(document).ready(function(){
	Common.ajax("GET","/payment/selectBillGroup.do", {"orderNo":ordNo}, function(result){
        groupListGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
        AUIGrid.setGridData(groupListGridID, result.data.selectGroupList);
	});
});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Order In Group</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->
<article id="grid_wrap" class="grid_wrap"></article>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

