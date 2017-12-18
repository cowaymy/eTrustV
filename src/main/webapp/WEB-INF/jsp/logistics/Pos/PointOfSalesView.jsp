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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var resGrid;
var reqGrid;
var serialGrid;

var rescolumnLayout=[{dataField:    "locid",headerText :"<spring:message code='log.head.location'/>"              ,width:120    ,height:30 ,visible:false},                         
                     {dataField: "stkid",headerText :"<spring:message code='log.head.itemcd'/>"             ,width:120    ,height:30 ,visible:false},                        
                     {dataField: "typenm",headerText :"<spring:message code='log.head.materialtype'/>"            ,width:120    ,height:30},                         
                     {dataField: "stkcd",headerText :"<spring:message code='log.head.materialcode'/>"               ,width:120    ,height:30},                       
                     {dataField: "stknm",headerText :"<spring:message code='log.head.text'/>"             ,width:120    ,height:30},                         
                     {dataField: "qty",headerText :"<spring:message code='log.head.availableqty'/>"       ,width:120    ,height:30, editable:true},                          
                     {dataField: "serialChk",headerText :"<spring:message code='log.head.serial'/>"       ,width:120    ,height:30} 
                    ];
                    
var serialLayout=[
					{dataField: "reqno",headerText :"<spring:message code='log.head.reqst_no'/>"            ,width:120    ,height:30  , visible:false},                         
					{dataField: "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"            ,width:120    ,height:30 , editable:false},                         
					{dataField: "itmname",headerText :"<spring:message code='log.head.text'/>"        ,width:180    ,height:30 , editable:false},                       
					{dataField: "serialNo",headerText :"<spring:message code='log.head.serialno'/>"     ,width:160    ,height:30},                          
					{dataField: "uom",headerText :"<spring:message code='log.head.uom'/>"               ,width:120    ,height:30 
                      ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                          var retStr = "";
                          
                          for(var i=0,len=uomlist.length; i<len; i++) {
                              if(uomlist[i]["codeId"] == value) {
                                  retStr = uomlist[i]["codeName"];
                                  break;
                              }
                          }
                          return retStr == "" ? value : retStr;
                          }
//                           ,EDITRENDERER : 
//                       {
//                          type : "ComboBoxRenderer",
//                          showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
//                          list : uomlist,
//                          keyField : "codeId",
//                          valueField : "codeName"
//                       }
                   }
                 ];                 
                    
                    
                    
var reqcolumnLayout;

var resop = {showRowCheckColumn : true , usePaging : true,useGroupingPanel : false , Editable:false};
var reqop = {showRowCheckColumn : true , usePaging : true,useGroupingPanel : false , Editable:true};
var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };

var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
    /**********************************
    * Header Setting
    ***********************************/
    
    var hdData;
    
    mainSearchFunc();
    
    doGetCombo('/common/selectCodeList.do', '15', '', 'cType', 'M','f_multiCombo');
    $("#cancelTr").hide();
    /**********************************
     * Header Setting End
     ***********************************/
    
    AUIGrid.bind(resGrid, "addRow", function(event){});
    AUIGrid.bind(reqGrid, "addRow", function(event){});
    
    AUIGrid.bind(resGrid, "cellEditBegin", function (event){});
    AUIGrid.bind(reqGrid, "cellEditBegin", function (event){});
    
    AUIGrid.bind(resGrid, "cellEditEnd", function (event){});
    AUIGrid.bind(reqGrid, "cellEditEnd", function (event){});
    
    AUIGrid.bind(resGrid, "cellClick", function( event ) {});
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(resGrid, "cellDoubleClick", function(event){});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event){
    	
   var reqno = AUIGrid.getCellValue(reqGrid, event.rowIndex, "reqno");
   var itmcd = AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd");
        destory(serialGrid);
    	$("#openwindow").show();
    	serialGrid = GridCommon.createAUIGrid("serial_grid_wrap", serialLayout,"", gridoptions);
    	ItemSerialAjax(reqno,itmcd);
    });
    
    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});
    
    AUIGrid.bind(reqGrid, "cellEditBegin", function (event){
    });
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
    	if (f_validatation('search')){
    	    //$("#slocation").val($("#tlocation").val());
    	}
    });
    $('#clear').click(function() {
    });
    $('#list').click(function() {
    	document.listForm.action = '/logistics/pos/PointOfSalesList.do';
        document.listForm.submit();
    });

    $("#sttype").change(function(){
    	paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    });
    $("#smtype").change(function(){
        
    });

});

function mainSearchFunc(){
	var param = "rStcode=${rStcode }";
	$.ajax({
        type : "GET",
        //url : "/logistics/stocktransfer/StocktransferDataDetail.do",
        url : "/logistics/pos/PosDataDetail.do",
        data : param,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        async:false,
        success : function(data) {
            hdData = data.hValue;
            headFunc(data.hValue);
            requestList(data.iValue);
            reciveList(data.itemto)
        },
        error: function(jqXHR, textStatus, errorThrown){
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        },
        complete: function(){
        }
    });
}



function headFunc(data){
	$("#reqno").val(data.reqno);
	$("#ReqDate").val(data.reqcrtdt);
	$("#Smo").val(data.refdocno);
	$("#reqtype").val(data.refdocno);
	$("#reqloc").val(data.reqcr);
	$("#Requestor").val(data.userName);
	
// 	paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
//     doGetComboData('/common/selectCodeList.do', paramdata, data.trntype ,'sttype', 'S' , '');
   
    paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:data.trntype};
    doGetComboData('/common/selectCodeList.do', paramdata, data.trndtl,'ReqType', 'S' , '');
    
    doGetCombo('/common/selectStockLocationList.do', '', data.rcivcr,'tlocation', 'S' , '');
    $("#tlocation").attr("disabled",true);
    doGetCombo('/common/selectStockLocationList.do', '', data.reqcr,'ReqLoc', 'S' , '');
    
	$("#ReqRemark").val(data.doctxt);
	
	$("#Smo").prop("readonly","readonly");
	$("#Requestor").prop("readonly","readonly");
	$("#ReqRemark").prop("readonly","readonly");
	$("#ReqDate").attr("disabled",true);
	$("#ReqType").attr("disabled",true);
	$("#smtype").attr("disabled",true);
	$("#ReqLoc").attr("disabled",true);
	//$("#dochdertxt").prop("class","readonly w100p");
	$("#pridic").val(data.prifr);
	
	//$("#reqcrtdate").prop("class","readonly w100p");//class="j_date"
}

function requestList(data){
	 reqcolumnLayout=[{dataField:   "resnoitm",headerText :"<spring:message code='log.head.item_no'/>"          ,width:120    ,height:30 , visible:false},                          
	                  {dataField:    "itmid",headerText :"<spring:message code='log.head.itemid'/>"          ,width:120    ,height:30 , visible:false},                          
	                  {dataField:    "reqno",headerText :"<spring:message code='log.head.reqst_no'/>"            ,width:120    ,height:30  , visible:false},                         
	                  {dataField:    "itmcd",headerText :"<spring:message code='log.head.materialcode'/>"            ,width:120    ,height:30 , editable:false},                         
	                  {dataField:    "itmname",headerText :"<spring:message code='log.head.text'/>"        ,width:120    ,height:30 , editable:false},                       
	                  {dataField:    "rqty",headerText :"<spring:message code='log.head.requestqty'/>"       ,width:120    ,height:30},                          
	                  {dataField:    "uom",headerText :"<spring:message code='log.head.uom'/>"               ,width:120    ,height:30 
                         ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                             var retStr = "";
                             
                             for(var i=0,len=uomlist.length; i<len; i++) {
                                 if(uomlist[i]["codeId"] == value) {
                                     retStr = uomlist[i]["codeName"];
                                     break;
                                 }
                             }
                             return retStr == "" ? value : retStr;
                         },editRenderer : 
                         {
                            type : "ComboBoxRenderer",
                            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                            list : uomlist,
                            keyField : "codeId",
                            valueField : "codeName"
                         }
                     }
                    ];
   
    reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout,"", gridoptions);
	
    AUIGrid.setGridData(reqGrid, data);
}


function reciveList(data){
	resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", gridoptions);
	AUIGrid.setGridData(resGrid, data);
}

function SearchListAjax() {

    var url = "/logistics/organization/MaintainmovementList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET" , url , param , function(data){
    	
    	
        //AUIGrid.setGridData(myGridID, data.data);
    });
}

function addRow() {
    var rowPos = "first";
       
    var item = new Object();
       
    AUIGrid.addRow(reqGrid, item, rowPos);
}

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

function f_multiCombo() {
    $(function() {
        $('#cType').change(function() {

        }).multipleSelect({
            selectAll : true
        });       
    });
}


function ItemSerialAjax(reqno,itmcd) {
	var param =
    {
			reqno    : reqno,
			itmcd     : itmcd
   };
//	var param = "reqno="+reqno;
    var url = "/logistics/pos/ViewSerial.do";

    Common.ajax("GET" , url , param , function(result){
     AUIGrid.setGridData(serialGrid, result.data);
    });
}

function destory(gridNm) {
    AUIGrid.destroy(gridNm);
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Other Request</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="post">
<input type='hidden' id='pridic' name='pridic' value='M'/>
<input type='hidden' id='headtitle' name='headtitle' value='STO'/>
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
    <th scope="row">Others Request</th>
    <td><input id="reqno" name="reqno" type="text" title="" placeholder="Automatic billing" class="readonly w100p" readonly="readonly" /></td>
    <th scope="row">Request Type</th>
    <td>
    <select class="w100p" id="ReqType" name="ReqType"></select> <!-- 기존 id="sttype" -->
    </td>
    

</tr>
<tr>
    <th scope="row">Request Date</th>
    <td><input id="ReqDate" name="ReqDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td> <!-- 기존 id="reqcrtdate" -->
    <th scope="row"></th>
    <td>
<!--     <select class="w100p" id="smtype" name="smtype"><option>Transfer Type Selected</option></select> -->
    </td>
</tr>
<tr>
    <th scope="row">Requestor</th>
    <td>
    <input id="Requestor" name="Requestor" type="text" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Stock Movement No</th>
    <td>
    <input id="Smo" name="Smo" type="text" title="" placeholder="" class="w100p" />
    </td>   
</tr>
<tr>
    <th scope="row">Request Location</th>
    <td colspan="3">
    <select class="w100p" id="ReqLoc" name="ReqLoc"></select> <!-- 기존 id="flocation" -->
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><input id="ReqRemark" name="ReqRemark" type="text" title="" placeholder="" class="w100p" /></td> <!-- 기존 id="dochdertxt" -->
</tr>
<tr id="cancelTr">
    <th scope="row">Defect Reason</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">CT/Cody</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!-- <section class="search_table">search_table start -->
<!-- <form id="searchFrom" method="post"> -->
<!-- <input type="hidden" id="slocation"> -->

<!-- <table class="type1">table start -->
<!-- <caption>table</caption> -->
<!-- <colgroup> -->
<!--     <col style="width:140px" /> -->
<!--     <col style="width:*" /> -->
<!--     <col style="width:100px" /> -->
<!--     <col style="width:*" /> -->
<!--     <col style="width:90px" /> -->
<!-- </colgroup> -->
<!-- <tbody> -->
<!-- <tr> -->
<!--     <th scope="row">Material Code</th> -->
<!--     <td> -->

<!--     <div class="date_set">date_set start -->
<!--     <p> -->
<!--     <select class="w100p"> -->
<!--         <option value="">11</option> -->
<!--         <option value="">22</option> -->
<!--         <option value="">33</option> -->
<!--     </select> -->
<!--     </p> -->
<!--     <span>~</span> -->
<!--     <p> -->
<!--     <select class="w100p"> -->
<!--         <option value="">11</option> -->
<!--         <option value="">22</option> -->
<!--         <option value="">33</option> -->
<!--     </select> -->
<!--     </p> -->
<!--     </div>date_set end -->

<!--     </td> -->
<!--     <th scope="row">Type</th> -->
<!--     <td > -->
<!--     <select class="w100p" id="cType" name="cType"></select> -->
<!--     </td> -->
<!--     <td> -->
<!--     <ul class="left_btns"> -->
<!--         <li><p class="btn_blue2"><a id="search">Search</a></p></li> -->
<!--     </ul> -->
<!--     </td> -->
<!-- </tr> -->
<!-- </tbody> -->
<!-- </table>table end -->

<!-- </form> -->
<!-- </section>search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto type2"><!-- divine_auto start -->

<div style="width:50%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Material Code</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="res_grid_wrap"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- 50% end -->

<div style="width:50%"><!-- 50% start -->

<aside class="title_line"><!-- title_line start -->
<h3>Request Item</h3>
</aside><!-- title_line end -->

<div class="border_box" style="height:340px;"><!-- border_box start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="req_grid_wrap" ></div>
</article><!-- grid_wrap end -->

<%-- <ul class="btns">
    <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li>
</ul> --%>

</div><!-- border_box end -->

</div><!-- 50% end -->

</div><!-- divine_auto end -->

<!-- <ul class="center_btns mt20"> -->
<!--     <li><p class="btn_blue2 big"><a id="save">Save</a></p></li> -->
<!-- </ul> -->

<div class="popup_wrap" id="openwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>View Serial</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <table class="type1">
            <caption>search table</caption>
            <colgroup id="serialcolgroup">
            </colgroup>
            <tbody id="dBody">
            </tbody>
            </table>
            <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
            </article><!-- grid_wrap end -->       
        </section>
    </div>

</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="reqno"     name="reqno"     value="${searchVal.reqno    }"/>
<input type="hidden" id="reqtype"    name="reqtype"    value="${searchVal.reqtype   }"/>
<input type="hidden" id="reqloc"    name="reqloc"    value="${searchVal.reqloc   }"/>
<%-- <input type="hidden" id="tlocation" name="tlocation" value="${searchVal.tlocation}"/> --%>
<%-- <input type="hidden" id="flocation" name="flocation" value="${searchVal.flocation}"/> --%>
<%-- <input type="hidden" id="crtsdt"    name="crtsdt"    value="${searchVal.crtsdt   }"/> --%>
<%-- <input type="hidden" id="crtedt"    name="crtedt"    value="${searchVal.crtedt   }"/> --%>
<%-- <input type="hidden" id="reqsdt"    name="reqsdt"    value="${searchVal.reqsdt   }"/> --%>
<%-- <input type="hidden" id="reqedt"    name="reqedt"    value="${searchVal.reqedt   }"/> --%>
<%-- <input type="hidden" id="sam"       name="sam"       value="${searchVal.sam      }"/> --%>
<%-- <input type="hidden" id="sstatus"   name="sstatus"   value="${searchVal.sstatus  }"/> --%>

</form>
</section>
