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


#editWindow {
    font-size:13px;
}
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var ttypedata = new Array();
var mtypedata = new Array();
var midata = new Array();

var decedata = [{"code":"H","codeName":"Credit"},{"code":"S","codeName":"Debit"}];
var stepdata = [{"code":"1","codeName":"1Step"},{"code":"2","codeName":"2Step"}];

var columnLayout;

$(document).ready(function(){
	// masterGrid 그리드를 생성합니다.
	ttypedata = f_getTtype('306','');
	mtypedata = f_getTtype('308','');
	midata    = f_getTtype('307','');
	
	doDefComboCode(ttypedata, '' ,"sttype", 'A', '');
	doDefComboCode(mtypedata, '' ,"smtype", 'A', '');
	
	columnLayout = [{dataField:"ttype"         ,headerText:"Transaction<br>Type Code"      ,width:120    ,height:30
                        ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                            var retStr = "";
                            for(var i=0,len=ttypedata.length; i<len; i++) {
                                if(ttypedata[i]["code"] == value) {
                                    retStr = ttypedata[i]["code"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },editRenderer : 
                        {
                           type : "ComboBoxRenderer",
                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                           list : ttypedata,
                           keyField : "code",
                           valueField : "codeName"
                        }
                    }
                    ,{dataField:"ttypedesc"       ,headerText:"Transaction<br>Type Text" , editable:false    ,width:250    ,height:30 , visible:true}
                    ,{dataField:"mtype"           ,headerText:"Movement<br>Type"               ,width:120    ,height:30
                    	,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                            var retStr = "";
                            for(var i=0,len=mtypedata.length; i<len; i++) {
                                if(mtypedata[i]["code"] == value) {
                                    retStr = mtypedata[i]["code"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },editRenderer : 
                        {
                           type : "ComboBoxRenderer",
                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                           listFunction : function(rowIndex, columnIndex, value, headerText, item){var list =  mtypedata; return list; },
                           keyField : "code",
                           valueField : "code"
                        }
                     }
                    ,{dataField:"mtypedesc"       ,headerText:"Movement<br>Type Text"      , editable:false     ,width:250    ,height:30 , visible:true}
                    ,{dataField:"cmtype"        ,headerText:"Cancel<br>Movement Type"       ,width:"12%"  ,height:30 
                    	,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
	                    
	                        var retStr = "";
	                        for(var i=0,len=mtypedata.length; i<len; i++) {
	                            if(mtypedata[i]["code"] == value) {
	                                retStr = mtypedata[i]["code"];
	                                break;
	                            }
	                        }
	                        return retStr == "" ? value : retStr;
	                    },editRenderer : 
	                    {
	                       type : "ComboBoxRenderer",
	                       showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
	                       listFunction : function(rowIndex, columnIndex, value, headerText, item){var list =  mtypedata; return list; },
	                       keyField : "code",
	                       valueField : "code"
	                    }
                    }
                    ,{dataField:"cmvt"    ,headerText:"Cancel<br>MVT"              ,width:120    ,height:30 , visible:true
                    	, renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"decr"         ,headerText:"Debit/Credit"            ,width:120    ,height:30
                    	,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                            
                            var retStr = "";
                            for(var i=0,len=decedata.length; i<len; i++) {
                                if(decedata[i]["code"] == value) {
                                    retStr = decedata[i]["code"];
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
                     }
                    ,{dataField:"decrdesc"     ,headerText:"Debit/Credit<br>Text"    ,width:120    ,height:30}
                    ,{dataField:"mvindict"        ,headerText:"Movement<br>Indicator"         ,width:90     ,height:30
                        ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                            
                            var retStr = "";
                            for(var i=0,len=midata.length; i<len; i++) {
                                if(midata[i]["code"] == value) {
                                    retStr = midata[i]["code"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },editRenderer : 
                        {
                           type : "ComboBoxRenderer",
                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                           list : midata,
                           keyField : "code",
                           valueField : "code"
                        }
                     }
                    ,{dataField:"mvindictdesc"         ,headerText:"Movement<br>Indicator Text"         ,width:90     ,height:30 , visible:true}
                    ,{dataField:"mretn"      ,headerText:"Return"       ,width:120    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"tstep"        ,headerText:"Transfer Step"       ,width:100    ,height:30
                        ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                            var retStr = "";
                            
                            for(var i=0,len=stepdata.length; i<len; i++) {
                                if(stepdata[i]["code"] == value) {
                                    retStr = stepdata[i]["codeName"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },editRenderer : 
                        {
                           type : "ComboBoxRenderer",
                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                           list : stepdata,
                           keyField : "code",
                           valueField : "codeName"
                        }
                     }
                    ,{dataField:"tranorgn"             ,headerText:"Transfer<br>Origin MVT" ,width:100    ,height:30
                        ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
                            var retStr = "";
                            for(var i=0,len=mtypedata.length; i<len; i++) {
                                if(mtypedata[i]["code"] == value) {
                                    retStr = mtypedata[i]["code"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },editRenderer : 
                        {
                           type : "ComboBoxRenderer",
                           showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                           list : mtypedata,
                           keyField : "code",
                           valueField : "code"
                        }
                     }
                    ,{dataField:"vender"        ,headerText:"Vender"          ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"cust"             ,headerText:"Customer"        ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"poflag"          ,headerText:"Purchase<br>Order"  ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"stflag"  ,headerText:"Stock<br>Transfer"  ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"ssoflag"             ,headerText:"Sales<br>Order"     ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"dnflag"      ,headerText:"Delivery<br>Number" ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"adjflag"           ,headerText:"Adjustment"           ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"resflag"       ,headerText:"Resevation"       ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"ganflag"           ,headerText:"G/L Account<br>Number"           ,width:100    ,height:30 , visible:true
                        , renderer : 
                        {
                            type : "CheckBoxEditRenderer",
                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0
                        }
                     }
                    ,{dataField:"ptype"     ,headerText:"ptype"  ,  editable : false , visible:false}
                   ];
    var options = {usePaging : false ,useGroupingPanel : false , showStateColumn : true};
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"ptype", options);
    
    AUIGrid.bind(myGridID, "addRow", function(event){});
    AUIGrid.bind(myGridID, "cellEditBegin", function (event){
    	
    	if (event.columnIndex == 0 || event.columnIndex == 2){
    		//if (AUIGrid.isAddedById(event.pid, event.item.id)){
    		if(AUIGrid.isAddedById(myGridID, event.item.ptype)) {
    			return true;
    		}else{
    		    return false;
    		}
        }    	
    });
    AUIGrid.bind(myGridID, "cellEditEnd", function (event){
    	var data;
    	var typevalue;
    	var typedesc;
    	
    	if (event.columnIndex == 0){
	        typevalue = AUIGrid.getCellValue(myGridID, event.rowIndex, "ttype");
	        data = ttypedata;
	        typedesc = "ttypedesc";
	        mtypedata = f_getTtype('308' , typevalue);
	    }else if (event.columnIndex == 2){
            typevalue = AUIGrid.getCellValue(myGridID, event.rowIndex, "mtype");
            data = mtypedata;
            typedesc = "mtypedesc";
        }
    	else if (event.columnIndex == 6){
            typevalue = AUIGrid.getCellValue(myGridID, event.rowIndex, "decr");
            data = decedata;
            typedesc = "decrdesc";
        }
    	else if (event.columnIndex == 8){
    		typevalue = AUIGrid.getCellValue(myGridID, event.rowIndex, "mvindict");
            data = midata;
            typedesc = "mvindictdesc";
        }
    	
    	$.each(data, function(index,value) {
            if (typevalue == data[index].code){
                AUIGrid.setCellValue(myGridID, event.rowIndex, typedesc , data[index].codeName);
                return false;
            }            
         });
    	
        //AUIGrid.setCellValue(myGridID, event.rowIndex, "ttypedesc" , itemtypevalue);
    });
    AUIGrid.bind(myGridID, "cellClick", function( event ) 
    {   
    });

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
    {
    });
    
    AUIGrid.bind(myGridID, "ready", function(event) {
    });
    
     SearchListAjax();

});

//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $('#clear').click(function() {
    	doDefCombo(ttypedata, '' ,"sttype", 'A', '');
        doDefCombo(mtypedata, '' ,"smtype", 'A', '');
        //SearchListAjax();
    });
    
    $("#download").click(function() {
        GridCommon.exportTo("grid_wrap", 'xlsx', "Maintain Movement Type");
    });
    
    $('#add').click(function() {
        addRow();
    });
    $('#delete').click(function(){
    	AUIGrid.removeRow(myGridID, "selectedIndex");
    	AUIGrid.removeSoftRows(myGridID);
    });
    $('#save').click(function() {
        
        Common.ajax("POST", "/logistics/organization/MovementIns.do", GridCommon.getEditData(myGridID), function(result) {
            Common.alert(result.message);
            AUIGrid.resetUpdatedItems(myGridID, "all");
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
            } catch (e) {
            }

            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    });
    $("#sttype").change(function(){
    	
    });
});

function SearchListAjax() {

    var url = "/logistics/organization/MaintainmovementList.do";
    var param = $('#searchForm').serializeJSON();
    
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(myGridID, data.data);

    });
}

function addRow() {
       var rowPos = "first";
       
       var item = new Object();
       item.ttype        = "";
       item.ttypedesc    = "";
       item.mtype        = "";
       item.mtypedesc    = "";
       item.cmtype       = "";
       item.cmvt         = "";
       item.decr         = "";
       item.decrdesc     = "";
       item.mvindict     = "";
       item.mvindictdesc = "";
       item.mretn        = "";
       item.tstep        = "";
       item.tranorgn     = "";
       item.vender       = "";
       item.cust         = "";
       item.poflag       = "";
       item.stflag       = "";
       item.ssoflag      = "";
       item.dnflag       = "";
       item.adjflag      = "";
       item.resflag      = "";
       item.ganflag      = "";
       item.ccflag       = "";
       item.onflag       = "";
       item.manflag      = "";
       

       
       AUIGrid.addRow(myGridID, item, rowPos);
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
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Movement Type</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Maintain-Movement Type</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" id="sUrl" name="sUrl">
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
    <th scope="row">Transaction Type</th>
    <td><select id="sttype" name="sttype" style="width:250px" class="w100p"></select></td>
    <th scope="row">Movement Type</th>
    <td><select id="smtype" name="smtype" style="width:250px" class="w100p"></select><p id='mtypenm'></p></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<!-- link_btns_wrap start -->
<aside class="link_btns_wrap">
</aside>

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a id="add"><spring:message code='sys.btn.add' /></a></p></li>
    <li><p class="btn_grid"><a id="save"><spring:message code='sys.btn.save' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="height:500px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section>
