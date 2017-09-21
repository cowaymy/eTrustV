<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid Properties 설정 
var gridPros = {            
		editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false,     // 상태 칼럼 사용
        // 사용자가 추가한 새행은 softRemoveRowMode 적용 안함. 
        // 즉, 바로 삭제함.
        //softRemovePolicy : "exceptNew"
        softRemoveRowMode : false
};

//AUIGrid 칼럼 설정
var columnLayout = [

    { dataField:"srvMemQuotId" ,headerText:"Quotation ID",editable : false ,visible : false},
    { dataField:"srvMemQuotIdTxt" ,headerText:"Quotation ID",editable : false ,visible : false},
    { dataField:"salesOrdId" ,headerText:"Sales Order ID",editable : false ,visible : false},
    { dataField:"custId" ,headerText:"cust ID",editable : false ,visible : false},
    { dataField:"appTypeId" ,headerText:"appTypeId",editable : false ,visible : false},    
    { dataField:"srvMemPacId" ,headerText:"Membership TypeId",editable : false ,visible : false},
    { dataField:"srvQuotValId" ,headerText:"Expired Date", editable : false ,visible : false, dataType : "date", formatString : "dd-mm-yyyy"},
    
    { dataField:"salesOrdNo" ,headerText:"Order No",width: 100 , editable : false },
    { dataField:"srvMemQuotNo" ,headerText:"Quotation No",width: 100 , editable : false },
    { dataField:"srvDur" ,headerText:"Duration",width: 70 , editable : false},
    { dataField:"srvFreq" ,headerText:"Frequent",width: 70 , editable : false },    
    { dataField:"custName" ,headerText:"Customer Name",editable : false},    
    { dataField:"stkDesc" ,headerText:"Product",width: 200,editable : false },    
    { dataField:"srvMemDesc" ,headerText:"Type",width: 180 ,editable : false},
    { dataField:"srvMemPacAmt" ,headerText:"Package Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"},
    { dataField:"srvMemBsAmt" ,headerText:"Filter Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"},
    { dataField:"totalAmt" ,headerText:"Total Charges",width: 100, editable : false ,dataType : "numeric", formatString : "#,##0.00",style : "aui-grid-user-custom-right"},
    {
        dataField : "",
        headerText : "",
        width: 100,
        renderer : {
            type : "ButtonRenderer",
            labelText : "Delete",
            onclick : function(rowIndex, columnIndex, value, item) {
                //alert(rowIndex);
                AUIGrid.removeRow(myGridID, "selectedIndex");
            }
        }
      }
    
    ];

$(document).ready(function(){
	// 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
});

function fn_search(){
    Common.popupDiv('/sales/membership/initSrchMembershipQuotationPop.do', '', null , true ,'_searchQuotation');
}

function _callBackQuotationPop(obj){	
	//팝업창 닫기
	$('#_searchQuotation').hide();
	$('#_searchQuotation').remove();
	
	//현재 그리드에서 Quotation ID 배열을 가져온다.
    var srvMemQuotIdTxtArray = AUIGrid.getColumnDistinctValues(myGridID,"srvMemQuotIdTxt");
	
	//추가하려는 객체의 Quotation ID값이 이미 존재하는지 체크
    if(srvMemQuotIdTxtArray.indexOf(obj.srvMemQuotIdTxt) > -1){
        Common.alert('<b>Selected Bill Existing in List.</b>');     
        return;
        
    }else{
        // parameter
        // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(myGridID, obj, "last" );
        
        $('#orderNo').val(obj.salesOrdNo);
        $('#quoNo').val(obj.srvMemQuotNo);
    }
}

</script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
    color:#d3825c;
}

</style>
<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	        <li>Billing</li>
	        <li>Manual Billing</li>
	        <li>Membership</li>
	</ul>
	
	<!-- title_line start -->
	<aside class="title_line">
	    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	    <h2>Membership</h2>	    
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_createBills();">Create Bills</a></p></li>
        </ul>
        
	</aside>
	<!-- title_line end -->
	
	<!-- search_table start -->
	<section class="search_table">
	    <form name="searchForm" id="searchForm"  method="post">
	        <!-- table start -->
	        <table class="type1 mt10">
	            <caption>table</caption>
	            <colgroup>
	                <col style="width:200px" />
	                <col style="width:*" />
	                <col style="width:200px" />
	                <col style="width:*" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row">Sales Order</th>
	                    <td>
	                        <input type="text" id="orderNo" name="orderNo" title="" placeholder="" class="readonly" readonly="readonly" />
	                    </td>
	                    <th scope="row">Membership Quotation</th>
	                    <td>
	                        <input type="text"  id="quoNo" name="quoNo"  title="" placeholder="" class="readonly" readonly="readonly" />
	                        <p class="btn_sky"><a href="javascript:fn_search();">Search</a></p>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	    </form>
	    <!-- table end -->
	    
	    <!-- grid_wrap start -->
	    <article  id="grid_wrap" class="grid_wrap mt30"></article>	    
	    <!-- grid_wrap end -->	    
	 
	</section><!-- search_table end -->
</section><!-- content end -->