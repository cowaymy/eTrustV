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
var listGrid;
var subGrid;


var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"period"       ,headerText:"Period"   ,dataType : "date",formatString : "mm/yyyy",width:120    ,height:30  , editable:false},
                     {dataField:"locid"        ,headerText:"Location"                    ,width:120    ,height:30 , visible:false},
                     {dataField:"loccd"        ,headerText:"Location"                    ,width:120    ,height:30 , editable:false},
                     {dataField:"locnm"        ,headerText:"Location Name"               ,width:120    ,height:30 , editable:false},
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , editable:false},
                     {dataField:"itmnm"        ,headerText:"Material Code Text"          ,width:120    ,height:30 , editable:false},
                     {dataField:"maxqty"       ,headerText:"Maximum Qty"                 ,width:120    ,height:30 , editable:true},
                     {dataField:"sftyqty"      ,headerText:"Safety Stock"                ,width:120    ,height:30 , editable:true},
                     {dataField:"reordqty"     ,headerText:"Reorder Qty"                 ,width:120    ,height:30 , editable:true},
                     {dataField:"avrqty"       ,headerText:"Average Qty"                 ,width:120    ,height:30 , editable:false}];
                     
// AUIGrid.showColumnByDataField(myGridID, "sftyqty"); 
// hideColumnByDataField
//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {
        rowIdField : "rnum",            
        //editable : true,
        //groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        editable : true,
        //showStateColumn : false,
        showBranchOnGrouping : false
        };
var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var paramdata;
var rABS; 
$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    doGetComboData('/common/selectCodeList.do', {groupCode : 339, orderValue : 'code'}, '','slocgb', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '11', '', 'scate', 'S',''); //CATEGORY LIST
    doGetCombo('/common/selectCodeList.do', '15', '', 'sttype', 'S',''); //TYPE LIST

    
    rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";
    
    /**********************************
     * Header Setting End
     ***********************************/
     
     createInitGrid();
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    AUIGrid.bind(subGrid, "ready", function(event) {
        
    });
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $("#clear").click(function(){
        $("#searchForm")[0].reset();
    });
    $("#sttype").change(function(){
       
    });
    $('#add').click(function(){
        $("#giopenwindow").show();
    });
    $('#save').click(function(){
        var dat = GridCommon.getEditData(listGrid);
        console.log(dat);
        Common.ajax("POST", "/logistics/replenishment/relenishmentSave.do", dat, function(result) {
            Common.alert(result.message , SearchListAjax);
        },  function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
            }

            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    });
    $('#popsave').click(function(){
        
        var param = $('#popForm').serializeJSON();
        
        if (validationchk()){
            Common.ajax("POST", "/logistics/replenishment/relenishmentPopSave.do", param, function(result) {
                Common.alert(result.message , SearchListAjax);
                $("#giopenwindow").hide();
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
    
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        }else{
            return false;
        }
    });
    $('#slocgb').change(function(){
        var paramdata ={"locgb":$('#slocgb').val()};
        doGetComboData('/common/selectStockLocationList.do', paramdata, '','sloccode', 'S' , '');
        if ($('#slocgb').val() == '03' || $('#slocgb').val() == '04'){
            AUIGrid.hideColumnByDataField(listGrid, "sftyqty");
        }else{
            AUIGrid.showColumnByDataField(listGrid, "sftyqty");
        }
    });
    $('#sloccode').change(function(){
    });
    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            alert("Your browser does not support HTML5. \r\nPlease fix it by uploading to the server.");
            return;
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                alert("Error selecting file!!");
                return;
            }
            var reader = new FileReader();

            reader.onload = function(e) {
                var data = e.target.result;
                var workbook;
                if(rABS) { // 일반적인 바이너리 지원하는 경우
                    workbook = XLSX.read(data, {type: 'binary'});
                } else { // IE 10, 11인 경우
                    var arr = fixdata(data);
                    workbook = XLSX.read(btoa(arr), {type: 'base64'});
                }
                
                var jsonObj = process_wb(workbook);

                createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
                //AUIGrid.setGridData(listGrid, jsonObj[Object.keys(jsonObj)[0]]);
            };

            if(rABS) reader.readAsBinaryString(file);
            else reader.readAsArrayBuffer(file);
            
        }
    });
    $('#upload').click(function() {
        $('#fileSelector').click();
    });
    
    $("#download").click(function() {
         GridCommon.exportTo("grid_wrap", 'xlsx', "Replenishment Data");
    });
    $("#itmnm").keyup(function(e) {
        if (event.which == '13') {
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            $("#svalue").val($("#itmnm").val());
            Common.searchpopupWin("popupForm", "/common/searchPopList.do","stock");
        }
    });
    $("#locnm").keyup(function(e) {
        if (event.which == '13') {
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");
            $("#svalue").val($("#locnm").val());
            Common.searchpopupWin("popupForm", "/common/searchPopList.do","location");
        }
    });
    $(".numberAmt").keyup(function(e) {
        //regex = /^[0-9]+(\.[0-9]+)?$/g;
        regex = /[^.0-9]/gi;

        v = $(this).val();
        if (regex.test(v)) {
            var nn = v.replace(regex, '');
            $(this).val(v.replace(regex, ''));
            $(this).focus();
            return;
        }
    });
});

function validationchk(){
    if ($("#period").val() == ''){
        Common.alert('Please enter a period.');
        return false;
    }
    if ($("#loccd").val() == ''){
        Common.alert('Please enter a Location.');
        return false;
    }
    if ($("#locnm").val() == ''){
        Common.alert('Please enter a Location.');
        return false;
    }
    if ($("#itmcd").val() == ''){
        Common.alert('Please enter a Material.');
        return false;
    }
    if ($("#itmnm").val() == ''){
        Common.alert('Please enter a Material.');
        return false;
    }
    if ($("#maxqty").val() == ''){
        Common.alert('Please enter a Maxmum Qty.');
        return false;
    }
    if ($("#reordqty").val() == ''){
        Common.alert('Please enter a Reorder Qty.');
        return false;
    }if ($("#sftyqty").val() == ''){
        Common.alert('Please enter a Safety Stock Qty.');
        return false;
    }
    return true;
}

function fn_itempopList(d){
    
    if (d[0].item.itemcode != undefined && d[0].item.itemcode != "undefined" && d[0].item.itemcode != null){
        $("#itmcd").val(d[0].item.itemcode);
        $("#itmnm").val(d[0].item.itemname);
    }
    
    if (d[0].item.loccd != undefined && d[0].item.loccd != "undefined" && d[0].item.loccd != null){
        $("#loccd").val(d[0].item.loccd);
        $("#locnm").val(d[0].item.locdesc);
        
        if (d[0].item.locgb == '01' || d[0].item.locgb == '02' || d[0].item.locgb == '05'){
            
            $("#sftyqty").prop("disabled", false);
        }else{
            $("#sftyqty").val(0);
            $("#sftyqty").prop("disabled", true);
        }
    }
}


function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        isCompatible = true;
    }
    return isCompatible;
}

function process_wb(wb) {
    var output = "";
    output = JSON.stringify(to_json(wb));
   
    output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
    return JSON.parse(output);
}

function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function(sheetName) {
        var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName], {defval:""});
        
        if(roa.length > 0){
            result[sheetName] = roa;
        }
    });
    return result;
}

// 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
function createAUIGrid(jsonData) {
    if(AUIGrid.isCreated(subGrid)) {
        AUIGrid.destroy(subGrid);
        subGrid = null;
    }
    
    var columnLayout = [];

    var firstRow = jsonData[0];

    if(typeof firstRow == "undefined") {
        alert("It is an Excel file that can not be converted.");
        return;
    }

    $.each(firstRow, function(n,v) {
        columnLayout.push({
            dataField : n,
            headerText : n,
            width : 100
        });
    });
    
    // 그리드 생성
    subGrid = AUIGrid.create("#grid_wrap", columnLayout);
    
    // 그리드에 데이터 삽입
    AUIGrid.setGridData(subGrid, jsonData);
    fn_detail(jsonData);

}

function createInitGrid() {
    
    var columnLayout = [];
    
    for(var i=0; i<10; i++) {
        columnLayout.push({
            dataField : "f" + i,
            headerText : String.fromCharCode(65 + i),
            width : 80
        });
    }
    
    // 그리드 속성 설정
    var gridPros = {
        noDataMessage : "로컬 PC의 엑셀 파일을 선택하십시오."
    };

    // 실제로 #grid_wrap 에 그리드 생성
    subGrid = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    
    // 그리드 최초에 빈 데이터 넣음.
    AUIGrid.setGridData(subGrid, []);
}

function fn_detail(data){
    var period;
    var location;
    var itmcd;
    var rowList = [];
    var iCnt = 0;
    for (var i = 1 ; i <= data.length ; i++){
        Common.ajaxSync("GET" , "/logistics/replenishment/exceldata.do" , data[i-1] , function(data){
            
            if (data != null){
            rowList[iCnt] = {
                    period   : data.PERIOD,
                    locid    : data.LOCID,
                    loccd    : data.LOCCD,
                    locnm    : data.LOCNM,
                    itmcd    : data.ITMCD,
                    itmnm    : data.ITMNM,
                    maxqty   : data.MAXQTY,
                    reordqty : data.REORDQTY,
                    sftyqty  : data.SFTYQTY,
                    avrqty   : 0
                }
                iCnt++;
            }
        });
    }

    AUIGrid.addRow(listGrid, rowList, "last");
}

function SearchListAjax() {
       
    var url = "/logistics/replenishment/searchList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Replenishment</li>
    <li>R.Mgmt Data</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>R.Mgmt Data</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
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
                    <th scope="row" rowspan='2'>Category of storage</th>
                    <td rowspan='2'>
                        <select class="w100p" id="slocgb" name="slocgb"></select>
                    </td>
                    <th scope="row" id=slocnm'>Location</th>
                    <td>
                        <select class="w100p" id="sloccode" name="sloccode"><option value="">Choose Category of Storage</option></select>
                    </td>
                    <th scope="row">Period</th>
                    <td>
                          <input id="speriod" name="speriod" type="text" title="period" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Material Category</th>
                    <td>
                        <select class="w100p" id="scate" name="scate"></select>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <div id='filediv' style="display:none;"><input type="file" id="fileSelector" name="files" accept=".xlsx"></div>
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="upload"><spring:message code='sys.btn.excel.up' /></a></p></li>
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
            <li><p class="btn_grid"><a id="add">Add</a></p></li>
            <li><p class="btn_grid"><a id="save">SAVE</a></p></li>
            
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
        
        <div id="grid_wrap" class="mt10" style="display:none;"></div>
    </section><!-- search_result end -->
   <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Issue Posting Data</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <form id="popForm" name="popForm" method="POST">
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:120px" />
                <col style="width:*" />
                <col style="width:120px" />
                <col style="width:*" />
                <col style="width:120px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">PERIOD</th>
                    <td ><input id="period" name="period" type="text" title="PERIOD" placeholder="MM/YYYY" class="j_date2" /></td>    
                    <th scope="row">Location</th>
                    <td ><input id="loccd" name="loccd" type="hidden" title="Location" class="w100p"/>
                         <input id="locnm" name="locnm" type="text" title="Location"  class="w100p"/>
                    </td>
                    <th scope="row">Meterial</th>
                    <td ><input id="itmcd" name="itmcd" type="hidden" title="Meterial"  class="w100p"/>
                         <input id="itmnm" name="itmnm" type="text" title="Meterial"  class="w100p"/>
                    </td>    
                </tr>
                <tr>
                    <th scope="row">Maximum Qty</th>
                    <td ><input id="maxqty"   name="maxqty" type="text"     title="Maximum Qty"  class="w100p numberAmt" /></td>    
                    <th scope="row">Reorder Qty</th>
                    <td ><input id="reordqty" name="reordqty" type="text"   title="Reorder Qty"  class="w100p numberAmt" /></td>
                    <th scope="row">Safty Stock</th>
                    <td ><input id="sftyqty"   name="sftyqty" type="text"   title="Safty Stock"  class="w100p numberAmt" /></td>    
                </tr>
            </tbody>
            </table>
        
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="popsave">SAVE</a></p></li> 
            </ul>
            </form>
        
        </section>
    </div>
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>
