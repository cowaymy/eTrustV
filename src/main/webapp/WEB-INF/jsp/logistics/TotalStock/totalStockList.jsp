<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var userCode;

                      
 var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"stkCode"       ,headerText:"Material Code"                      ,width:120    ,height:30 },
                      {dataField:"stkDesc"      ,headerText:"Material Name"      ,width:120    ,height:30                },
                      {dataField:"ctgryId"        ,headerText:"CategoryID"               ,width:120    ,height:30,visible:false  },
                      {dataField:"ctgryName"      ,headerText:"Category"                      ,width:120    ,height:30                },
                      {dataField:"typeId"     ,headerText:"TypeID" ,width:120    ,height:30,visible:false },
                      {dataField:"typeName"        ,headerText:"Type"            ,width:120    ,height:30 },
                      {dataField:"locDesc"        ,headerText:"Location"               ,width:120    ,height:30 },
                      {dataField:"qty"       ,headerText:"QTY"               ,width:120    ,height:30},
                      {dataField:"movQty"      ,headerText:"Move QTY"       ,width:120    ,height:30                },
                      {dataField:"bookingQty"        ,headerText:"Booking QTY"         ,width:120    ,height:30                },
                      {dataField:"availableQty"        ,headerText:"Available Qty"         ,width:120    ,height:30                }
                      ];                     
                                    
//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false , 
        editable : false, 
        pageRowCount : 30, 
        usePaging : true, 
        useGroupingPanel : false,
        };
        
var subgridpros = {
        // 페이지 설정
        usePaging : true,                
        pageRowCount : 20,                
        editable : false,                
        noDataMessage : "출력할 데이터가 없습니다.",
        enableSorting : true,
        //selectionMode : "multipleRows",
        //selectionMode : "multipleCells",
        useGroupingPanel : true,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        //softRemoveRowMode:false
        };
var resop = {
        rowIdField : "rnum",            
        editable : true,
        fixedColumnCount : 6,
        groupingFields : ["reqstno"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showRowAllCheckBox : true,
        showBranchOnGrouping : false
        };


        
var paramdata;

$(document).ready(function(){
    
    SearchSessionAjax();
    /**********************************
    * Header Setting
    **********************************/
    var LocData = {sLoc : userCode};
    //doGetComboCodeId('/common/selectStockLocationList.do',LocData, '','searchLoc', 'S' , '');
    doGetComboCodeId('/common/selectStockLocationList.do','', '','searchLoc', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiCombo');
    doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos'); 
       
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridoptions);    
    
    
    $("#sub_grid_wrap").hide(); 

    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
     
    
    
});


//btn clickevent
$(function(){
    $('#search').click(function() {
        if (f_validatation()){
        SearchListAjax();
        }
    });

});

function SearchSessionAjax() {
    var url = "/logistics/totalstock/SearchSessionInfo.do";
    Common.ajaxSync("GET" , url , '' , function(result){
        userCode=result.UserCode;
        $("#LocCode").val(userCode);
    });
}


function SearchListAjax() {
    var url = "/logistics/totalstock/totStockSearchList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

function f_validatation(v){
             
            if ($("#searchLoc").val() == null || $("#searchLoc").val() == undefined || $("#searchLoc").val() == ""){
                Common.alert("Please Select Location.");
                return false;
            }
            return true;
}

function f_LocMultiCombo() {
    $(function() {
        $('#searchLoc').change(function() {
            
            $("#searchLoc").val(userCode);
        });
    });
}


function f_multiCombo() {
    $(function() {
        $('#searchType').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */        
    });
}
function f_multiCombos() {
    $(function() {
        $('#searchCtgry').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */ 
    });
}



</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Total Stock List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Total Stock List</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
      <li><p class="btn_gray"><a id="clear"><span class="clear"></span>Clear</a></p></li>
      <li><p class="btn_gray"><a id="search"><span class="search"></span>Search</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="LocCode" id="LocCode" />    
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                <th scope="row">Material Code</th>
                   <td >
                      <input type="text" title="" placeholder=""  class="w100p" id="searchMatCode" name="searchMatCode"/>
                    </td> 
                    <th scope="row">Location</th>
                    <td>
                        <select class="w100p" id="searchLoc" name="searchLoc"><option value=''>Choose One</option></select>
                    </td> 
                </tr>
                <tr>
                    <th scope="row">Category</th>
                    <td>
                        <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                    </td>
                    <th scope="row">Type</th>
                    <td>
                        <select class="w100p" id="searchType" name="searchType"></select>
                    </td>         
                </tr>
                             
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
    
        <ul class="right_btns">
<!--          <li><p class="btn_grid"><a id="insert"><span class="search"></span>INS</a></p></li>             -->
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        

    </section><!-- search_result end -->

</section>

