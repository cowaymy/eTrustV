<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
	/* 드랍 리스트 왼쪽 정렬 재정의*/
	.aui-grid-drop-list-ul {
	    list-style:none;
	    margin:0;
	    padding:0;
	    text-align:left;
	}
	.aui-grid-drop-list-content {
	    display: inline-block;
	    border-radius: 0px;
	    margin: 0;
	    padding: 0;
	    cursor: pointer;
	    overflow: hidden;
	    font-size: 1em;
	    line-height: 2em;
	    vertical-align: top;
	    text-align: left;
	}
	/* 커스텀 칼럼 스타일 정의 */
	.aui-grid-user-custom-left {
	    text-align:left;
	}
	/* 커스텀 disable 스타일*/
	.mycustom-disable-bold {
	    font-weight: bold;
	}
</style>

<script type="text/javaScript" language="javascript">
    var ctm;
    var branchTypeId = '${branchTypeId}';
    var memType = '${memberTypeId}';

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var branchList =[];
    var ctCodeList = [];

    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {dataField : "promoId", headerText : "Branch", width : 120}];
        // AUIGrid 칼럼 설정
        var columnLayout =
            [
				{
				    dataField : "code",
				    headerText : "Branch",
				    width: 280,
				    editenderer : {
				        type : "DropDownListRenderer",
				        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
				        descendants : [ "memCode" ], // 자손 필드들
				        descendantDefaultValues : [ "-" ], // 변경 시 자손들에게 기본값 지정
				        list : branchList,
				        keyField   : "codeId", //key 에 해당되는 필드명
				        valueField : "codeName"        //value 에 해당되는 필드명
				    },
				    style : "aui-grid-user-custom-left",
				    editable : false
				},
				{
				    dataField : "memCode",
				    headerText : "DT",
				    width: 280,
				    editenderer : {
				        type : "DropDownListRenderer",
				        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
				        listFunction : function(rowIndex, columnIndex, item, dataField) {
				            return ctCodeList;
				        },
				        keyField   : "memId", //key 에 해당되는 필드명
				        valueField : "memCode"        //value 에 해당되는 필드명
				    },
				    style : "aui-grid-user-custom-left",
				    editable : false
				},
                {dataField : "codeId",        headerText : "Branch1",       width: 0},
                {dataField : "memId",        headerText : "CT1",             width: 0},
                {headerText : "Morning", children : [
                    {dataField: "morngSesionAs",     headerText: "AS",     dataType: "numeric",  editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "morngSesionIns",    headerText: "INS",    dataType: "numeric",   editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "morngSesionRtn",    headerText: "RTN",   dataType: "numeric",  editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60}
                ]},
                {headerText : "Afternoon", children : [
                    {dataField: "aftnonSesionAs",     headerText: "AS",     dataType: "numeric",   editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "aftnonSesionIns",    headerText: "INS",    dataType: "numeric",   editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "aftnonSesionRtn",    headerText: "RTN",   dataType: "numeric",  editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60}
                ]},
                {headerText : "Evening", children : [
                    {dataField: "evngSesionAs",       headerText: "AS",     dataType: "numeric",   editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "evngSesionIns",       headerText: "INS",    dataType: "numeric",  editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60},
                    {dataField: "evngSesionRtn",      headerText: "RTN",   dataType: "numeric",  editRenderer : {type : "InputEditRenderer", onlyNumeric : true}, width:60}
                ]}
            ];

        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            displayTreeOpen : true,
            headerHeight : 30,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            showStateColumn : false
        };

        // Create AUIGrid
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "memCode", gridPros);

        AUIGrid.bind(myGridID, "cellEditBegin", function (event){
            var ctm_row = -1;

            if( ctm ) {
                if ( AUIGrid.getRowIndexesByValue(myGridID, "memCode", ctm) != null && AUIGrid.getRowIndexesByValue(myGridID, "memCode", ctm) != ""
                        && AUIGrid.getRowIndexesByValue(myGridID, "memCode", ctm) >= 0 ) {
                    ctm_row = AUIGrid.getRowIndexesByValue(myGridID, "memCode", ctm);
                } else {
                    ctm_row = -1;
                }
            }

            if (event.rowIndex == ctm_row) {
                return false;
            }else{
                return true;
            }
        });
    }

    // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        fn_getCtCodeSearch1();

	    $("#cmbbranchId").change(function (){
	        doGetCombo('/organization/seleCtCodeSearch2.do',  $("#cmbbranchId").val(), '','cmbctId', 'S' ,  '');
	    });

	    // 에디팅 정상 종료, 취소 이벤트 바인딩
        AUIGrid.bind(myGridID, ["cellEditEnd", "cellEditCancel"], auiCellEditingHandler);
    });

    // 편집 핸들러
    function auiCellEditingHandler(event) {
        var item = new Object();
            item.codeId="";
	        item.memId="";

        if(event.columnIndex  ==0) {
        	fn_getCtCodeSearch(event.value);
            AUIGrid.setCellValue(myGridID, event.rowIndex , "codeId", event.value);
            AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", "");
        }

        if(event.columnIndex  ==1) {
        	  AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", event.value);
         }
    };

    // 리스트 조회.
    function fn_getSsCapacityBrListAjax() {
    	$("#branchTypeId").val(branchTypeId);
    	$("#memType").val(memType);

        Common.ajax("GET", "/organization/selectSsCapacityCtList", $("#searchForm").serialize(), function(result1) {
            AUIGrid.setGridData(myGridID, result1);
            ctm = "";

            Common.ajax("GET", "/organization/selectSsCapacityCTM", $("#searchForm").serialize(), function(result2) {
                if (result2.length > 1) {
	            	Common.alert("There are several DTM in the branch.<br/>Can't collect capacity to DTM from DT.");
	            } else if (result2.length == 0) {
	            	Common.alert("There is no DTM in the branch.<br/>Can't collect capacity to DTM from DT.");
	            } else {
	            	ctm = result2[0]["ctmCode"];
	            }
            });
        });
    }

    function addRow() {
		if($("#cmbbranchId").val() == '') {
		    Common.alert("Please Select Branch Type");
		    return false;
		}
		if($("#cmbctId").val() == '') {
		    Common.alert("Please Select CT Code");
		    return false;
		}

	    var item = new Object();

	    if($("#cmbbranchId option:selected").val() == '') {
      	    //fn_getCtCodeSearch1();
        } else {
            item.code =  $("#cmbbranchId option:selected").text();
            item.brnchId1 = $("#cmbbranchId option:selected").val();
            item.codeId = $("#cmbbranchId option:selected").val();

            if($("#cmbctId option:selected").val() != '') {
          	    item.memCode =  $("#cmbctId option:selected").text();
          	    item.ctId1 =  $("#cmbctId option:selected").val();
          	    item.memId =  $("#cmbctId option:selected").val();
            }
        }
	    AUIGrid.addRow(myGridID, item, "first");
    }

    function fn_save() {
        Common.ajax("POST", "/homecare/services/plan/saveHcCapacityList.do", GridCommon.getEditData(myGridID), function(result) {
        	Common.alert(result.message, fn_getSsCapacityBrListAjax());
        });
    }

    function removeRow(){
        var selectedItems = AUIGrid.getSelectedItems(myGridID);

        if(selectedItems.length <= 0 ){
            Common.alert("There Are No selected Items.");
            return ;
        }
        AUIGrid.removeRow(myGridID, "selectedIndex");
        AUIGrid.removeSoftRows(myGridID);
    }

    function fn_excelDown(){
        GridCommon.exportTo("grid_wrap", "xlsx", "CT Session Capacity");
    }

    function fn_getCtCodeSearch(_brnch){
        Common.ajax("GET", "/organization/seleCtCodeSearch.do",{brnch:_brnch}, function(result) {
            ctCodeList = result;
        }, null, {async : false});
    }

    function fn_getCtCodeSearch1(){
        Common.ajax("GET", "/organization/seleBranchCodeSearch.do",{groupCode: branchTypeId}, function(result) {
        	for( i in result) {
        		branchList.push(result[i]);
        	}
        }, null, {async : false});
    }

    // 엑셀 업로드
    function fn_uploadFile() {
        var formData = new FormData();
        formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);

        Common.ajaxFile("/organization/excel/saveCapacityByExcel.do"
            , formData
            , function (result) {
                if(result.code == "99"){
                    Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                }else{
                    Common.alert(result.message);
                }
        });
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
	<h2>DT Session Capacity</h2>
	</aside><!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
		<form action="#" method="post" id="searchForm">
            <input type="hidden" id="branchTypeId" name="branchTypeId" />
            <input type="hidden" id="memType" name="memType" />

            <!-- title_line start -->
			<aside class="title_line">
				<h3>Search Option</h3>
				<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				    <li>
				    <div class="auto_file"><!-- auto_file start -->
				    <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
				    </div><!-- auto_file end -->
				    </li>
				</c:if>
				<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
				    <li><p class="btn_blue"><a onclick="javascript:fn_uploadFile()">UPLOAD</a></p></li>
				</c:if>
				<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getSsCapacityBrListAjax();"><span class="search"></span>Search</a></p></li>
				</c:if>
				</ul>
			</aside>
			<!-- title_line end -->

			<!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
				    <col style="width:200px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Branch</th>
					    <td>
					        <select id="cmbbranchId" name="cmbbranchId" class="w100p" style='text-align:left' >
						        <option value="">Choose One</option>
						         <c:forEach var="list" items="${dscBranchList}">
						            <option value="${list.codeId}" style='text-align:left'>${list.codeName}</option>
						         </c:forEach>
					         </select>
					    </td>
					    <th scope="row">DT Code</th>
					    <td><select id="cmbctId" name="cmbctId" class="w100p" style='text-align:left'></select></td>
					    <th scope="row">Status</th>
					    <td>
					        <select id="status" name="status" class="w100p" style='text-align:left' >
					            <option value="">Choose One</option>
					            <option value="Active">Active</option>
					            <option value="Complete">Complete</option>
					        </select>
					    </td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result"><!-- search_result start -->
		<aside class="title_line"><!-- title_line start -->
		<h3>DT Capacity Configuration</h3>
		<ul class="right_btns">
		<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
		    <li><p class="btn_grid"><a href="#" onclick="fn_excelDown()">TEMPLATE</a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		    <li><p class="btn_grid"><a href="#" onclick="fn_save()">SAVE</a></p></li>
		</c:if>
		</ul>
		</aside>
		<!-- title_line end -->

		<article class="grid_wrap"><!-- grid_wrap start -->
		      <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article>
        <!-- grid_wrap end -->
	</section>
	<!-- search_result end -->

</section><!-- content end -->

