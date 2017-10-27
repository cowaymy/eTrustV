<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var myGridID;
var myGridID2;//AREA
var subList;
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
    var list = [ "DSC-01-01", "DSC-01-02" ];
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
        width : 130
    }, {
        dataField : "memId",
        headerText : "",
        editable : false,
        width : 0
    }, {
        dataField : "ctSubGrp",
        headerText : "CTSubGroup",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                var list = getUseYnComboList();
                return list;
            },
            keyField : "id"
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
        formatString : "yyyy/mm/dd",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
          },
        width : 130
    }, {
        dataField : "priodTo",
        headerText : "Priod To",
        dataType : "date",
        formatString : "yyyy/mm/dd",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
          },
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

$(document).ready(function() {
	CTSubgGroupGrid();
	CTSubAreaGroupGrid();
	$("#grid_wrap_ctaAreaSubGroup").hide();
	
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
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>CT Sub Group Search</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CT Sub Group Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_CTSubGroupSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
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
    <th scope="row">Region</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
        </select>
    </td>
    <th scope="row">City</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
        </select>
    </td>
    <th scope="row">Town</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Postal Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
        </select>
    </td>
    <th scope="row">Street</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Area ID</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
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
    <td><input type="text" title="" placeholder="" class="w100p" id="dscCode" name="dscCode"/></td>
    <th scope="row">CTM</th>
    <td><input type="text" title="" placeholder="Martin" class="w100p" /></td>
    <th scope="row">CT Sub Group</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">CT</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Local/Out Station</th>
    <td>
        <select class="multy_select w100p" multiple="multiple">
        </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p">
        <option value="">Complete</option>
        <option value="">Progress</option>
    </select>
    </td>
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
    <label><input type="radio" name="name" checked="checked" onclick="fn_radioButton(1)" /><span>CT Sub Group Display</span></label>
    <label><input type="radio" name="name" onclick="fn_radioButton(2)"/><span>Sub Group – Area Display</span></label>
    </td>
</tr>
</tbody>
</table>


<aside class="title_line"><!-- title_line start -->
<h4>Information Display</h4>
</aside><!-- title_line end -->

<ul class="right_btns">
   <!--  <li><p class="btn_grid"><a href="#">Edit</a></p></li> -->
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_CTSubGroupSave()">Save</a></p></li>
<!--     <li><p class="btn_grid"><a href="#">Outstation Schedule Maintenance</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_openAreaMain()">CT Sub Group – Area ID Maintenance</a></p></li> -->
</ul>
  
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_ctSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
<div id="grid_wrap_ctaAreaSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
