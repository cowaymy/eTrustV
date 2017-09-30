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
var decedata = [{"code":"H","codeName":"Credit"},{"code":"S","codeName":"Debit"}];

 var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"reqstno"      ,headerText:"Others Request No"      ,width:120    ,height:30                },
                      {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30 , visible:false              },
                      {dataField:"mtext"        ,headerText:"Request Type"               ,width:120    ,height:30                },
                      {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30                },
                      {dataField:"reqitmno"     ,headerText:"Stock Movement Request Item" ,width:120    ,height:30 , visible:false},
                      {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                      {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                      {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30,        visible:false},
                      {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30                },
                      {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30                },
                      {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                      {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                      {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30 ,visible:false               },
                      {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                      {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                      {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30 ,visible:false               },
                      {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:true},
                      {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                      {dataField:"reqstqty"     ,headerText:"Others Request QTY"                 ,width:120    ,height:30                },
                      {dataField:"rmqty"        ,headerText:"Remain Qty"                 ,width:120    ,height:30                },
                      {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"delyqty"      ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                      {dataField:"greceipt"     ,headerText:"Good Receipt"                ,width:120    ,height:30,  visible:false  },
                      {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                      {dataField:"serialChk"        ,headerText:"Serial Chk"             ,width:120    ,height:30                },
                      {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                }];     
                      
                      
     var mtrcolumnLayout = [
                            {dataField:"matrlDocNo", headerText:"Matrl_Doc_No" ,width:120    ,height:30},
                            {dataField:"matrlDocItm", headerText:"MatrlDocItm" ,width:120    ,height:30},
                            {dataField:"invntryMovType", headerText:"Move_type" ,width:120    ,height:30},                     
                            {dataField:"movtype", headerText:"Move_text" ,width:120    ,height:30},                            
                            {dataField:"reqStorgNm", headerText:"ReqLoc" ,width:150    ,height:30},
                            {dataField:"matrlNo", headerText:"Matrl_Code" ,width:120    ,height:30},
                            {dataField:"stkDesc", headerText:"MatrlName" ,width:120    ,height:30},
                            {dataField:"debtCrditIndict", headerText:"Debit/Credit" ,width:120    ,height:30
                              ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                                    
                                    var retStr = "";
  
                                    for(var i=0,len=decedata.length; i<len; i++) {

                                        if(decedata[i]["code"] == value) {
                                            retStr = decedata[i]["codeName"];
                                            break;
                                        }
                                    }
                                    return retStr == "" ? value : retStr;
                                },editRenderer : 
                                {
                                   type : "ComboBoxRenderer",
                                   showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                   list : decedata,
                                   keyField : "code",
                                   valueField : "code"
                                }	
                          
                            },
                            {dataField:"autoCrtItm", headerText:"" ,width:120    ,height:30},
                            {dataField:"qty", headerText:"Qty" ,width:120    ,height:30},
                            {dataField:"trantype", headerText:"tran_Type" ,width:120    ,height:30},
                            {dataField:"postingdate", headerText:"PostingDate" ,width:120    ,height:30},                            
                            {dataField:"codeName", headerText:"Uom" ,width:120    ,height:30},             
               ];                   
                                    
var options = {usePaging : true,useGroupingPanel : false};
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
    /**********************************
    * Header Setting
    **********************************/
       doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '','searchStatus', 'S' , '');
	   doGetCombo('/common/selectStockLocationList.do', '', '','searchLoc', 'S' , '');
	   var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:'OH'};
       doGetComboData('/common/selectCodeList.do', paramdata, '','searchReqType', 'S' , 'SearchListAjax');     
       doGetComboData('/logistics/pos/selectPosReqNo.do','' , '','searchOthersReq1', 'S' , '');
       doGetComboData('/logistics/pos/selectPosReqNo.do','', '','searchOthersReq2', 'S' , '');
       
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    //listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, subgridpros);
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);    
    mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", options);
    $("#mdc_grid").hide(); 

    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
        $("#mdc_grid").hide(); 

        if (event.dataField == "reqstno"){
        	SearchMaterialDocListAjax(event.value)
        }
        

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
        $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
        document.searchForm.action = '/logistics/pos/PosView.do';
        document.searchForm.submit();
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    
    AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {
        
        var reqno = AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno");
        
        if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)){
            AUIGrid.addCheckedRowsByValue(listGrid, "reqstno" , reqno);
        }else{
            var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);

            for (var i = 0 ; i < rown.length ; i++){
                AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
            }
        }
    });  
 });
    
function f_onchange(obj, value, tag, selvalue){
	var reqNo= value;
	var paramdata = { groupCode : reqNo};
	doGetComboData('/logistics/pos/selectPosReqNo.do',paramdata, '','searchOthersReq2', 'S' , '');
}

//btn clickevent
$(function(){
    $('#search').click(function() {
    	//if(valiedcheck('search')){
        SearchListAjax();
    	//}
    });
    $('#insert').click(function(){
         document.searchForm.action = '/logistics/pos/PosOfSalesIns.do';
         document.searchForm.submit();
    });

    $("#goodIssue").click(function(){
     $("#giForm")[0].reset();
     var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
     console.log(checkedItems);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
        	  for (var i = 0 ; i < checkedItems.length ; i++){
                  if(checkedItems[i].item.serialChk == 'Y' && checkedItems[i].item.status == 'O'){
                      Common.alert('Please enter the Serial Number.');
                      return false;
                      break;
                  }else if(checkedItems[i].item.status == 'C'){
                       Common.alert('Complete!');
                       return false;
                       break;
                  }             
              }  	       	
            document.giForm.gitype.value="GI";
            $("#dataTitle").text("Good Issue Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
            $("#giopenwindow").show();
        }
    });

    
    $("#issueCancel").click(function(){
    	var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
            for (var i = 0 ; i < checkedItems.length ; i++){
                if(checkedItems[i].item.status == 'S' || checkedItems[i].item.status == 'O'){
                    Common.alert('Already processed.');
                    return false;
                    break;
                }
            }
            document.giForm.gitype.value="GC";
            $("#dataTitle").text("Issue Cancel Posting Data");
            doSysdate(0 , 'giptdate');
            doSysdate(0 , 'gipfdate');
            $("#giopenwindow").show();
        }
    });
    
      
    
});

function SearchListAjax() {
   
    var url = "/logistics/pos/PosSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

function GiSaveAjax() {
	   
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItems(listGrid);
    data.checked = checkdata;
    data.form = $("#giForm").serializeJSON();

    Common.ajaxSync("POST", "/logistics/pos/PosGiSave.do", data, function(result) {

        Common.alert(result.message);

        // AUIGrid.resetUpdatedItems(listGrid, "all");
        $("#giptdate").val("");
        $("#gipfdate").val("");
        $("#giopenwindow").hide();
         $('#search').click();

    }, function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
    
}


function giSave() {
	if(valiedcheck('save')){
	GiSaveAjax();
	}
}

 function valiedcheck(v) {
	var ReqType;
	var Location;
	var Status;
if(v=='search'){
    if ($("#searchReqType").val() == "") {
        ReqType = false;
    }else{
    	ReqType = true;
    }
    if ($("#searchLoc").val() == "") {
        Location = false;
    }else{
    	Location = true;
    } 
    if ($("#searchStatus").val() == "") {
        Status = false;
    }else{
    	Status = true;
    }   

    if(ReqType == false && Location == false && Status == false){  
    	alert("Please select the Request Type. \nPlease select the Location.\nPlease key in the Status.");
        return false;
    }
    if(ReqType == true || Location == true || Status == true){	
    	  return true;
    }
    
}else if(v=='save'){
	
	  if ($("#giptdate").val() == "") {
          Common.alert("Please select the GI Posting Date.");
          $("#giptdate").focus();
          return false;
      }
	  if ($("#gipfdate").val() == "") {
          Common.alert("Please select the GI Proof Date.");
          $("#gipfdate").focus();
          return false;
      }
	  if ($("#doctext").val() == "") {
          Common.alert("Please enter the Header Text.");
          $("#doctext").focus();
          return false;
      }
	  return true;
}   
    
    
} 


function SearchMaterialDocListAjax( reqno ) {
    var url = "/logistics/pos/MaterialDocumentList.do";
    var param = "reqstno="+reqno;
    $("#mdc_grid").show(); 
    
    Common.ajax("GET" , url , param , function(data){
        AUIGrid.resize(mdcGrid,1620,150); 
        AUIGrid.setGridData(mdcGrid, data.data2);        
    });
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


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Point Of Sales List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Other GI/GR List</h2>
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
                <th scope="row">Others Request</th>
                   <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><select class="w100p" id="searchOthersReq1" name="searchOthersReq1"   onchange="f_onchange('' , this.value , '', '')"></select></p>   
                        <span> ~ </span>
                        <p><select class="w100p" id="searchOthersReq2" name="searchOthersReq2"></select></p>
                         </div> <!-- date_set end -->
                    </td> 
                    <th scope="row">Request Type</th>
                    <td>
                        <select class="w100p" id="searchReqType" name="searchReqType"><option value=''>Choose One</option></select>
                    </td> 
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
                </tr>
                
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
    
        <ul class="right_btns">
         <li><p class="btn_grid"><a id="insert"><span class="search"></span>INS</a></p></li>            
         <li><p class="btn_grid"><a id="goodIssue">Good Issue</a></p></li>
         <li><p class="btn_grid"><a id="issueCancel">Issue Cancel</a></p></li>
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:300px"></div>
        

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Issue Posting Data</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
        <form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gitype" id="gitype" value="GI"/> 
<!--             <input type="hidden" name="serialqty" id="serialqty"/> -->
<!--             <input type="hidden" name="reqstno" id="reqstno"/> -->
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">GI Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                    <th scope="row">GI Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
                <tr>    
                    <th scope="row">Header Text</th>
                    <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
                </tr>
            </tbody>
            </table>
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
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a onclick="javascript:giSave();">SAVE</a></p></li>
            </ul>
            </form>
        
        </section>
    </div>

    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Compliance Remark</a></li>
        </ul>
        
        <article class="tap_area"><!-- tap_area start -->
        
            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="mdc_grid" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->
        
        </article><!-- tap_area end -->
            
        
    </section><!-- tap_wrap end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

