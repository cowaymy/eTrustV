<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var memId;
var myGridID;
var myGridID2;//AREA
var subList = new Array();
//popup 크기
var option = {
        winName : "popup",
        width : "1200px",   // 창 가로 크기
        height : "400px",    // 창 세로 크기
        resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
        scrollbars : "no" // 스크롤바. (yes/no)(default : yes)
};

//subList=rsult.list;
function getUseYnComboList() {
	  
}
function getLocalComboList(){
    var list = [ "Local", "OutStation"];
    return list;
}
function getServiceWeekComboList() {
    var list = [ "1", "2", "3", "4" ];
    return list;
}
function CTSubgGroupGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : "DSC",
        editable : false,
        width : 130
    }, {
        dataField : "name",
        headerText : "CTM",
        editable : false,
        width : 230
    }, {
        dataField : "memCode",
        headerText : "CT",
        editable : false,
        width : 280
    }, {
        dataField : "memId",
        headerText : "memId",
        editable : false,
        width : 0
    }, {
        dataField : "ctSubGrp",
        headerText : "CT Sub Group",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                var list = subList;
                return list;
            },
            keyField : "ctSubGrp",
            valueField : "codeName",
        }
    
    
    }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
             fixedColumnCount    : 1,            
             showStateColumn     : false,             
             displayTreeOpen     : false,            
/*              selectionMode       : "singleRow",  //"multipleCells",    */         
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_ctSubGroup", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};

function CTSubAreaGroupGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "areaId",
        headerText : "Area ID",
        editable : false,
        width : 100
    }, {
        dataField : "area",
        headerText : "Area",
        editable : false,
        width : 120
    }, {
        dataField : "city",
        headerText : "City",
        editable : false,
        width : 130
    }, {
        dataField : "postcode",
        headerText : "Postal Code",
        editable : false,
        width : 100
    }, {
        dataField : "state",
        headerText : "State",
        editable : false,
        width : 130
    }, {
        dataField : "locType",
        headerText : "Local Type",
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                var list = getLocalComboList();
                return list;
            },
          },
        width : 130
    }, {
        dataField : "svcWeek",
        headerText : "Service Week",
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                var list = getServiceWeekComboList();
                return list;
            },
        width : 100
      }
    }, {
        dataField : "ctSubGrp",
        headerText : "Sub Group",
        width :130
    }, {
        dataField : "priodFrom",
        headerText : "Priod From",
        dataType : "date",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
          },
        onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
        width : 130
    }, {
        dataField : "priodTo",
        headerText : "Priod To",
        dataType : "date",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
          },
        onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
             fixedColumnCount    : 1,            
             showStateColumn     : false,             
             displayTreeOpen     : false,            
/*              selectionMode       : "singleRow",  //"multipleCells",    */         
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID2 = AUIGrid.create("#grid_wrap_ctaAreaSubGroup", columnLayout, gridPros);
}

var gridPros = {
    
		usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false
    
};



function f_multiCombo() {
         $(function(event) {
        	 $('#dscCode').change(function(event) {
             }).multipleSelect({
                 selectAll : true, // 전체선택 
                 width : '80%'
             }).blur(function(){

                 alert("This input field has lost its focus.");

              });
             
       });
}


function fn_onchange(){
   //alert(222);
   // var brnchCode = $("#dscCode").val();
    //alert(333);
    //doGetCombo('/services/mileageCileage/selectCTM', {brnchCode:brnchCode}, '','memCode', 'M' ,  '');

} 

$(document).ready(function() {
	//DSCCODE
	 doGetCombo('/services/holiday/selectBranchWithNM', 43, '','dscCode', 'S' ,  '');
	 doGetCombo('/services/holiday/selectState.do', '' , '', 'state' , 'S', '');
	CTSubgGroupGrid();
	CTSubAreaGroupGrid();
	$("#grid_wrap_ctaAreaSubGroup").hide();
	
	
	
	 AUIGrid.bind(myGridID, "cellClick", function(event) {
	        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
	        branchCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code");
	        var memIdName = AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode");
	        memId = memIdName.split('-');
	        Common.ajax("GET", "/services/serviceGroup/selectCTSubGroupDscList.do", {branchCode:branchCode}, function(result) {
	            console.log("성공.");
	            console.log("data : " + result);
	            subList = new Array()
	            for (var i = 0; i < result.length; i++) {
	                var list = new Object();
	                list.ctSubGrp = result[i].codeId;
	                list.codeName = result[i].codeName;
	                subList.push(list);
	                 }
	            return subList;
	            //AUIGrid.setGridData(myGridID, result);
	        });
	        
	        //memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
	        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
	    }); 
	 
	 $("#state").change(function(){
		 
		 doGetCombo('/services/holiday/selectCity.do',  $("#state").val(), '','city', 'S' ,  ''); 
		 
	 });
	 
	 $("#dscCode").change(function (){
	        doGetCombo('/services/serviceGroup/selectCTMByDSC',  $("#dscCode").val(), '','memCode', 'S' ,  ''); 
	        doGetCombo('/services/serviceGroup/selectCTSubGrb',  $("#dscCode").val(), '','ctSubGrp', 'S' ,  ''); 
	 });
	 
});

function fn_CTSubGroupSearch(){
	Common.ajax("GET", "/services/serviceGroup/selectCTSubGroup.do", $("#CTSearchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
	
	Common.ajax("GET", "/services/serviceGroup/selectCTSubAreaGroup.do", $("#CTSearchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID2, result);
    });
}

function fn_CTSubGroupSave(){
	if(GridCommon.getEditData(myGridID) != null ){
		Common.ajax("POST", "/services/serviceGroup/saveCTSubGroup.do", GridCommon.getEditData(myGridID), function(result) {
	        console.log("성공.");
	        console.log("data : " + result);
	    });
	}
	
	if(GridCommon.getEditData(myGridID2) != null){
		Common.ajax("POST", "/services/serviceGroup/saveCTSubAreaGroup.do", GridCommon.getEditData(myGridID2), function(result) {
            console.log("성공.");
            console.log("data : " + result);
        });
	}
	
}

function fn_openAreaMain(){
    Common.popupDiv("/services/serviceGroup/openAreaMainPop.do?isPop=true","" );
}

function fn_radioButton(val){
	if(val == 1){
		   $("#grid_wrap_ctSubGroup").show();
		   $("#grid_wrap_ctaAreaSubGroup").hide();
	}else{
			 $("#grid_wrap_ctaAreaSubGroup").show();
			 $("#grid_wrap_ctSubGroup").hide();
	}
}

// 엑셀 내보내기(Export);
function fn_exportTo() {
    var radioVal = $("input:radio[name='name']:checked").val();
    
    if (radioVal == 1 ){
        GridCommon.exportTo("grid_wrap_ctSubGroup", 'xlsx', "Service Group_ctSubGroup");
    } else {
        GridCommon.exportTo("grid_wrap_ctaAreaSubGroup", 'xlsx', "Service Group_ctaAreaSubGroup");
    }
};

function fn_uploadFile() 
{
   var formData = new FormData();
   console.log("read_file: " + $("input[name=uploadfile]")[0].files[0]);
   formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
   
   var radioVal = $("input:radio[name='name']:checked").val();
   formData.append("radioVal", radioVal );

   //alert('read');
   
   if( radioVal == 1 ){
	   Common.ajaxFile("/services/serviceGroup/excel/updateCTSubGroupByExcel.do"
               , formData
               , function (result) 
                {
                     //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                     if(result.code == "99"){
                         Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                     }else{
                         Common.alert(result.message);
                     }
            });
   } else {
	   Common.ajaxFile("/services/serviceGroup/excel/updateCTAreaByExcel.do"
               , formData
               , function (result) 
                {
                    //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                	if(result.code == "99"){
                        Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                    }else{
                        Common.alert(result.message);
                    }
            });
   }

}

function fn_Clear(){
    
    //hash
	$("#state").val("");
	$("#city").val("");
	$("#area").val("");
	$("#postCode").val("");
	$("#areaId").val("");
	$("#dscCode").val("");
	$("#memCode").val("");
	$("#ctSubGrp").val("");
	$("#CTMemId").val("");
}

function fn_CTSubAssign(){  
	  var checkedItems  = AUIGrid.getSelectedItems(myGridID);
	  

      if(checkedItems.length <= 0) {
          Common.alert('No data selected.');
          return false;
      }
	
	
	memId = memId[0];
	var jsonObj=  { "memId" : memId};
    Common.popupDiv("/services/serviceGroup/ctSubGroupPop.do" ,  jsonObj , null , true , '_NewAddDiv1');
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>CT Sub Group Search</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Service Group</h2>
<ul class="right_btns">
	
    <li>
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
    </div><!-- auto_file end -->
    </li>
    <li><p class="btn_blue"><a onclick="javascript:fn_uploadFile();">Update Request</a></p></li>

    <!-- <li><p class="btn_blue"><a href="#" onclick="javascript:fn_CTSubGroupUpdateRequest()">Update Request</a></p></li> -->
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_CTSubGroupSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="CTSearchForm">

<aside class="title_line"><!-- title_line start -->
<h4>General Info.</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
 <th scope="row">State</th>
    <td>
        <select class="w100p" id="state" name="state"></select>
   </td>
    
    <th scope="row">City</th>
    <td>
        <select class="w100p" id="city" name="city"></select>
    </td>
    <th scope="row">Area</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p"  id="area" name="area" >
    </td>
</tr>
<tr>
    <th scope="row">Postal Code</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p"  id="postCode" name="postCode">
    </td>
    <th scope="row"></th>
    <td>
        
    </td>
    <th scope="row">Area ID</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="areaId" name="areaId"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h4>Assign Info.</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DSC Branch</th>
    <td><select class="w100p"  id="dscCode" name="dscCode" ></select></td>
    <th scope="row">CTM</th>
    <td><select class="w100p"id="memCode" name="memCode" ></select></td>
    <th scope="row">CT Sub Group</th>
    <td><select class="w100p"id="ctSubGrp" name="ctSubGrp"></select></td>
</tr>
<tr>
    <th scope="row">CT</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="CTMemId" name="CTMemId"/></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
<!--     <th scope="row">Local/Out Station</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="station" name="station">
        </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p">
        <option value="">Complete</option>
        <option value="">Progress</option>
    </select>
    </td> -->
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">Magic Address Download</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td>
    <label><input type="radio" name="name" value="1" checked="checked" onclick="fn_radioButton(1)" /><span>CT Sub Group Display</span></label>
    <label><input type="radio" name="name" value="2" onclick="fn_radioButton(2)"/><span>Sub Group – Area Display</span></label>
    </td>
</tr>
</tbody>
</table>


<aside class="title_line"><!-- title_line start -->
<h4>Information Display</h4>
</aside><!-- title_line end -->

<ul class="right_btns">
   <!--  <li><p class="btn_grid"><a href="#">Edit</a></p></li> -->
     <li><p class="btn_grid"><a href="#" onclick="javascript:fn_CTSubAssign()">CT Sub Assignment</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_exportTo()">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_CTSubGroupSave()">SAVE</a></p></li>
<!--     <li><p class="btn_grid"><a href="#">Outstation Schedule Maintenance</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_openAreaMain()">CT Sub Group – Area ID Maintenance</a></p></li> -->
</ul>
  
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_ctSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
<div id="grid_wrap_ctaAreaSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
