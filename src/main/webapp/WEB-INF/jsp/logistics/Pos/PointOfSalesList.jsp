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


var rescolumnLayout=[
                     {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"posNo"      ,headerText:"Others Request No"      ,width:120    ,height:30 ,visible:true},
                     {dataField:"posItmQty"      ,headerText:"Others Request Item"                      ,width:120    ,height:30,    visible:true            },
                     {dataField:""     ,headerText:"Request Type" ,width:120    ,height:30 , visible:true},
                     {dataField:"codeName1"        ,headerText:"Request Type Text"            ,width:120    ,height:30 , visible:true},
                     {dataField:"posDt"        ,headerText:"Request Required Date"       ,width:120    ,height:30 ,   visible:true      },
                     {dataField:"posCrtDt"        ,headerText:"Request Create Date"               ,width:120    ,height:30 , visible:true},
                     {dataField:"whLocCode"        ,headerText:"Location"               ,width:120    ,height:30,     visible:true           },
                     {dataField:"name"       ,headerText:"Requstor"               ,width:120    ,height:30,   visible:true             },
                     {dataField:"stkCode"        ,headerText:"Material code"         ,width:120    ,height:30 ,  visible:true              },
                     {dataField:"stkDesc"      ,headerText:"Material code Name"       ,width:120    ,height:30 ,  visible:true             },
                     {dataField:"serialChk"       ,headerText:"Serial"               ,width:120    ,height:30 , visible:true},
                     {dataField:""     ,headerText:"Request Qty"               ,width:120    ,height:30 , visible:true},
                     {dataField:""   ,headerText:"Unit of Measure"               ,width:120    ,height:30, visible:true},
                     {dataField:""       ,headerText:""                 ,width:120    ,height:30 , visible:false},
                     {dataField:""     ,headerText:""                 ,width:120    ,height:30 , visible:false},
                     {dataField:""   ,headerText:""                 ,width:120    ,height:30, visible:false },
                     {dataField:""        ,headerText:""               ,width:120    ,height:30 , visible:false},
                     {dataField:""      ,headerText:""               ,width:120    ,height:30 ,visible:false},
                     {dataField:""     ,headerText:""                 ,width:120    ,height:30 ,visible:false },
                     {dataField:""       ,headerText:""                      ,width:120    ,height:30 , visible:false},
                     {dataField:""      ,headerText:""                ,width:120    ,height:30 ,visible:false},
                     {dataField:""     ,headerText:""                ,width:120    ,height:30  ,visible:false },
                     {dataField:""          ,headerText:""             ,width:120    ,height:30 , visible:false},
                     {dataField:""        ,headerText:""             ,width:120    ,height:30   ,visible:false } ];
                     
var resop = {
        rowIdField : "rnum",            
        //editable : true,
        groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        enableCellMerge : true,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
var paramdata;

$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
       doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '','searchStatus', 'S' , '');
	   doGetCombo('/common/selectStockLocationList.do', '', '','searchLoc', 'S' , '');
	   var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:'OI'};
       doGetComboData('/common/selectCodeList.do', paramdata, '','searchReqType', 'S' , '');
	   
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridoptions);

    $("#sub_grid_wrap").hide(); 

    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        $("#sub_grid_wrap").hide(); 

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
});
function f_change(){
    $("#sttype").change();
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	if(valiedcheck()){
        SearchListAjax();
    	}
    });
    $('#insert').click(function(){
         document.searchForm.action = '/logistics/pos/PosOfSalesIns.do';
         document.searchForm.submit();
    });
});

function SearchListAjax() {
   
    var url = "/logistics/pos/PosSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
    	console.log(data.data);
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}


 function valiedcheck() {
	var ReqType;
	var Location;
	var Status;
	
    if ($("#searchReqType").val() == "") {
        Common.alert("Please select the Request Type.");
        $("#searchReqType").focus();
        ReqType = false;
    }else{
    	ReqType = true;
    }
    if ($("#searchLoc").val() == "") {
        Common.alert("Please select the Location.");
        $("#searchLoc").focus();
        Location = false;
    }else{
    	Location = true;
    } 
    if ($("#searchStatus").val() == "") {
        Common.alert("Please key in the Status.");
        $("#searchStatus").focus();
        Status = false;
    }else{
    	Status = true;
    }   

    if(ReqType == true || Location == true || Status == true){	
        return true;
    }else{
    	return false;
    }

} 


// function SearchDeliveryListAjax( reqno ) {
//     var url = "/logistics/stockMovement/StockMovementRequestDeliveryList.do";
//     var param = "reqstno="+reqno;
//     //$("#sub_grid_wrap").show(); 
//     $("#mdc_grid").show(); 
    
//     Common.ajax("GET" , url , param , function(data){
//         AUIGrid.setGridData(subGrid, data.data);
//         AUIGrid.resize(mdcGrid,1620,150); 
//         AUIGrid.setGridData(mdcGrid, data.data2);
//         console.log(data.data2);
//     });
// }

function f_getTtype(g , v){
    var rData = new Array();
    $.ajax({
           type : "GET",
           url : "/common/selectCodeList.do",
           data : { groupCode : g , orderValue : 'CRT_DT' , likeValue:v},
           dataType : "json",
           contentType : "application/json;charset=UTF-8",
           async:false,
           success : function(data) {
              $.each(data, function(index,value) {
                  var list = new Object();
                  list.code = data[index].code;
                  list.codeId = data[index].codeId;
                  list.codeName = data[index].codeName;
                  rData.push(list);
                });
           },
           error: function(jqXHR, textStatus, errorThrown){
               alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });
    
    return rData;
} 


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Point Of Sales List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Point Of Sales List</h2>
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
        <input type="hidden" name="rStcode" id="rStcode" />    
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                <th scope="row">Others Request</th>
                   <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><select class="w100p" id="searchOthersReq1" name="searchOthersReq1"></select></p>   
                        <span> ~ </span>
                        <p><select class="w100p" id="searchOthersReq2" name="searchOthersReq2"></select></p>
                        </div><!-- date_set end -->
                    </td> 
                    <th scope="row">Request Type</th>
                    <td>
                        <select class="w100p" id="searchReqType" name="searchReqType"><option value=''>Choose One</option></select>
                    </td>
                    <td colspan="2">&nbsp;</td>   
                </tr>
                <tr>
                    <th scope="row">Location</th>
                    <td>
                        <select class="w100p" id="searchLoc" name="searchLoc"></select>
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="searchStatus" name="searchStatus"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date" value="${searchVal.reqsdt}" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date" value="${searchVal.reqedt}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td> 
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="insert"><span class="search"></span>INS</a></p></li>            
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        

    </section><!-- search_result end -->
    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Material Document Info</a></li>
          <!--   <li><a href="#">Compliance Remark</a></li> -->
        </ul>
        
        <article class="tap_area"><!-- tap_area start -->
        
            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="sub_grid_wrap" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->
        
        </article><!-- tap_area end -->
            
        
    </section><!-- tap_wrap end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

