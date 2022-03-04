<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
	/* 커스텀 칼럼 스타일 정의 */
	.aui-grid-user-custom-left {
	    text-align:left;
	}
	.aui-grid-link-renderer > a {
        text-decoration:underline;
        color: #4374D9 !important;
    }

</style>

<script type="text/javaScript">
	var branchCode;
	var myGridID;
	var myGridID2; // AREA
	var branchTypeId = '${branchTypeId}';

	var subList = new Array();
    var localList = ["Local", "OutStation"];

    // 그리드 속성 설정
    var gridPros = {
        usePaging                   : true,        // 페이징 사용
        pageRowCount            : 20,           // 한 화면에 출력되는 행 개수 20(기본값:20)
        editable                      : true,
        fixedColumnCount        : 1,
        showStateColumn         : false,
        displayTreeOpen          : false,
        headerHeight               : 30,
        useGroupingPanel         : false,       // 그룹핑 패널 사용
        skipReadonlyColumns    : true,        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove       : true,        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,        // 줄번호 칼럼 렌더러 출력
    };

	function DTSubgGroupGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [
            {dataField : "code",               headerText : "DSC",                 editable : false,               width : 130},
            {dataField : "name",              headerText : "DTM",                 editable : false,               width : 300},
            {dataField : "memCode",        headerText : "DT",                   editable : false,               width : 350,               style : "aui-grid-user-custom-left"},
            {dataField : "memId",            headerText : "memId",              editable : false,               width : 0},
            {dataField : "ctSubGrp",         headerText : "DT Sub Group",    width : 120,
                editRenderer : {
                    type : "ComboBoxRenderer",
		            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
		            listFunction : function(rowIndex, columnIndex, item, dataField) {
		                return subList;
		            }, keyField : "ctSubGrp", valueField : "codeName"
		        }
            }
        ];

	    myGridID = AUIGrid.create("#grid_wrap_dtSubGroup", columnLayout, gridPros);
	}

	function DTSubAreaGroupGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [
            {dataField : "areaId",                  headerText : "Area ID",                  editable : false,               width : 100},
            {dataField : "area",                     headerText : "Area",                      editable : false,               width : 200},
            {dataField : "city",                      headerText : "City",                       editable : false,               width : 150},
            {dataField : "postcode",              headerText : "Postal Code",            editable : false,               width : 100},
            {dataField : "state",                    headerText : "State",                      editable : false,               width : 130},
            {dataField : "locType",                headerText : "Local Type",              width : 130,
                editRenderer : {
                    type : "ComboBoxRenderer",
	                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
	                listFunction : function(rowIndex, columnIndex, item, dataField) {
	                    return localList;
	                },
	            }
            },
            {dataField : "noSvcCnt",              headerText : "No Service Date",        editable : false,               width : 100,
            	renderer : {type : "LinkRenderer", linkField : "noSvcCnt",
            		baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                    // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                    jsCallback : function(rowIndex, columnIndex, value, item) {
                    	fn_noSvcCntCellClick(rowIndex);
                    }
                }
            },
            {dataField : "ctSubGrp",              headerText : "Sub Group",               width :130},
            {dataField : "ctBrnchCode",         headerText : "ctBrnchCode",             width :0}
        ];

	    myGridID2 = AUIGrid.create("#grid_wrap_dtaAreaSubGroup", columnLayout, gridPros);
	}

	// Ready
	$(document).ready(function() {
		//doGetCombo('/services/holiday/selectBranchWithNM', 43, '','dscCode', 'S' ,  '');
		doGetCombo('/homecare/selectHomecareBranchCd.do', branchTypeId, '','dscCode', 'S', '');
		doGetCombo('/services/holiday/selectState.do', '' , '', 'state' , 'S', '');

		DTSubgGroupGrid();
		DTSubAreaGroupGrid();

		$("#grid_wrap_dtaAreaSubGroup").hide();

		AUIGrid.bind(myGridID, "cellClick", function(event) {
            if(branchCode !=  AUIGrid.getCellValue(myGridID, event.rowIndex, "code")) {
            	branchCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code");

                Common.ajax("GET", "/homecare/services/plan/selectDTSubGroupDscList.do", {branchCode:branchCode}, function(result) {
                    subList = new Array()
                    for (var i = 0; i < result.length; i++) {
                            var list = new Object();
                            list.ctSubGrp = result[i].codeId;
                            list.codeName = result[i].codeName;
                            subList.push(list);
                         }
                    return subList;
                });
            }
	    });

		$("#state").change(function(){
		    doGetCombo('/services/holiday/selectCity.do',  $("#state").val(), '','city', 'S' ,  '');
		});

		$("#dscCode").change(function (){
		    doGetCombo('/homecare/services/plan/selectDTMByDSC', $("#dscCode").val(), '', 'memCode', 'S' ,  '');
		    doGetCombo('/homecare/services/plan/selectDTSubGrp', $("#dscCode").val(), '', 'ctSubGrp', 'S' ,  '');
	    });
	});

	// no Service Count Cell Click Event
	function fn_noSvcCntCellClick(rowIndex){
		var jsonObj=  {
            "area" : AUIGrid.getCellValue(myGridID2, rowIndex, "area"),
            "areaID" : AUIGrid.getCellValue(myGridID2, rowIndex, "areaId"),
            "ctSubGrp" : AUIGrid.getCellValue(myGridID2, rowIndex, "ctSubGrp"),
            "subGrpType" : 6666
        };

        // 년 달력 팝업 창 호출
        fn_DTSubGroupCalendar(jsonObj);
	}

	// 조회
	function fn_CTSubGroupSearch(){
		$("#branchTypeId").val(branchTypeId);
		branchCode = "";

		Common.ajax("GET", "/homecare/services/plan/selectDtSubGroupList.do", $("#DTSearchForm").serialize(), function(result) {
	        AUIGrid.setGridData(myGridID, result);

	        Common.ajax("GET", "/homecare/services/plan/selectDTSubAreaGroupList.do", $("#DTSearchForm").serialize(), function(result) {
	            AUIGrid.setGridData(myGridID2, result);
	        });
	    });
	}

	// 저장
	function fn_DTSubGroupSave(){
		if(GridCommon.getEditData(myGridID) != null ){
			Common.ajax("POST", "/services/serviceGroup/saveCTSubGroup.do", GridCommon.getEditData(myGridID), function(result) {
			    Common.alert(" CT Sub Group Upload "+DEFAULT_DELIMITER + result.message);

	            if(result.code == "00"){
	                // 성공시에 재조회
		            fn_CTSubGroupSearch();
		        }
		    });
        }
	}

	/* function fn_openAreaMain(){
	    Common.popupDiv("/services/serviceGroup/openAreaMainPop.do?isPop=true","" );
	} */

	function fn_radioButton(val){
		if(val == 1) {
		    $("#grid_wrap_dtSubGroup").show();
		    $("#grid_wrap_dtaAreaSubGroup").hide();
		    // 버튼 보이게 한다.
		    $("#hiddenBtn1").show();
            $("#hiddenBtn2").show();
            $("#hiddenBtn3").show();

		    AUIGrid.resize(myGridID);

		} else {
		    $("#grid_wrap_dtaAreaSubGroup").show();
		    $("#grid_wrap_dtSubGroup").hide();
		    // 버튼 안보이게 한다.
		    $("#hiddenBtn1").hide();
            $("#hiddenBtn2").hide();
            $("#hiddenBtn3").hide();

		    AUIGrid.resize(myGridID2);
		}
	}

	// 엑셀 내보내기(Export);
	function fn_exportTo() {
	    var radioVal = $("input:radio[name='name']:checked").val();

	    if (radioVal == 1 ){
	        GridCommon.exportTo("grid_wrap_dtSubGroup", 'xlsx', "Service Group_ctSubGroup");
	    } else {
	        GridCommon.exportTo("grid_wrap_dtaAreaSubGroup", 'xlsx', "Service Group_ctaAreaSubGroup");
	    }
	};

	// 엑셀 업로드
	function fn_uploadFile() {
	    var formData = new FormData();
	    formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);

        Common.ajaxFile("/services/serviceGroup/excel/updateCTSubGroupByExcel.do", formData, function (result) {
			Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);

            if(result.code == "00"){
                // 성공시에 재조회
                fn_CTSubGroupSearch();
            }
        });
	}

	// Clear
	function fn_Clear(){
	    $("#DTSearchForm").find("input, select").val("");
	}

	function fn_DTSubAssign(){
	    var checkedItems = AUIGrid.getSelectedItems(myGridID);

	    if(checkedItems.length <= 0) {
	        Common.alert('No data selected.');
	        return false;
        }

		var jsonObj = {
            "memId" : AUIGrid.getCellValue(myGridID, checkedItems[0].rowIndex, "memId"),
            "branchCode" : branchCode
        };
	    Common.popupDiv("/homecare/services/plan/hcDTSubGroupPop.do" ,  jsonObj , null , true , '_NewAddDiv1');
    }

	// 서비스 일자 달력 팝업
	function fn_DTSubGroupCalendar(jsonObj) {
	    Common.popupDiv("/services/serviceGroup/cTSubGroupServiceDay.do", jsonObj, null , true, '_groupCalDiv');
	}

</script>

<!-- content start -->
<section id="content">
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Organization</li>
	    <li>DT Sub Group Search</li>
	</ul>
    <!-- title_line start -->
	<aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Service Group</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		    <li>
		    <div class="auto_file"><!-- auto_file start -->
		    <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
		    </div><!-- auto_file end -->
		    </li>
		    </c:if>
		    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
		    <li><p class="btn_blue"><a onclick="javascript:fn_uploadFile();">UPLOAD</a></p></li>
		    </c:if>
		    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
		    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_CTSubGroupSearch()"><span class="search"></span>Search</a></p></li>
		    </c:if>
		    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside>
    <!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
        <form action="#" method="post" id="DTSearchForm">
            <input type ="hidden" id="branchTypeId" name="branchTypeId">
			<aside class="title_line"><!-- title_line start -->
	            <h4>General Info.</h4>
			</aside><!-- title_line end -->

	        <!-- table start -->
			<table class="type1">
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
					        <input type="text" class="w100p"  id="area" name="area" >
					    </td>
					</tr>
					<tr>
					    <th scope="row">Postal Code</th>
					    <td>
					        <input type="text" class="w100p"  id="postCode" name="postCode">
					    </td>
					    <th scope="row"></th>
					    <td>
					    </td>
					    <th scope="row">Area ID</th>
					    <td><input type="text" class="w100p" id="areaId" name="areaId"/></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<aside class="title_line"><!-- title_line start -->
	            <h4>Assign Info.</h4>
			</aside><!-- title_line end -->

	        <!-- table start -->
			<table class="type1">
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
					    <th scope="row">HDSC Branch</th>
					    <td><select class="w100p"  id="dscCode" name="dscCode" ></select></td>
					    <th scope="row">DTM</th>
					    <td><select class="w100p"id="memCode" name="memCode" ></select></td>
					    <th scope="row">DT Sub Group</th>
					    <td><select class="w100p"id="ctSubGrp" name="ctSubGrp"></select></td>
					</tr>
					<tr>
					    <th scope="row">DT</th>
					    <td><input type="text" class="w100p" id="DTMemId" name="DTMemId"/></td>
					    <th scope="row"></th>
					    <td></td>
					    <th scope="row"></th>
					    <td></td>
					</tr>
				</tbody>
			</table>
            <!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:*" />
		</colgroup>
		<tbody>
            <tr>
			    <td>
			    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
			    <label><input type="radio" name="name" value="1" checked="checked" onclick="fn_radioButton(1)" /><span>DT Sub Group Display</span></label>
			    </c:if>
			    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
			    <label><input type="radio" name="name" value="2" onclick="fn_radioButton(2)"/><span>Sub Group – Area Display</span></label>
			    </c:if>
			    </td>
			</tr>
		</tbody>
	</table>

    <!-- title_line start -->
	<aside class="title_line">
    	<h4>Information Display</h4>
	</aside>
	<!-- title_line end -->

	<ul class="right_btns">
        <li></li>
        <li id="hiddenBtn1"><p class="btn_grid"><a href="#" onclick="javascript:fn_DTSubAssign()">DT Sub Assignment</a></p></li>
	    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	    <li id="hiddenBtn2"><p class="btn_grid"><a href="#" onclick="javascript:fn_exportTo()">TEMPLATE</a></p></li>
	    </c:if>
	    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	    <li id="hiddenBtn3"><p class="btn_grid"><a href="#" onclick="javascript:fn_DTSubGroupSave()">SAVE</a></p></li>
	    </c:if>
	</ul>

    <!-- grid_wrap start -->
	<article class="grid_wrap">
		<div id="grid_wrap_dtSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
		<div id="grid_wrap_dtaAreaSubGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
	</article>
    <!-- grid_wrap end -->
</section><!-- content end -->

