<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의*/

.my-columnCenter0 {
    text-align : center;
    background : #EFFFCC;
    color : #000;
}
.my-columnCenter1 {
    text-align : center;
    background : #F5F2DC;
    color : #000;
}
.my-columnLeft0 {
    text-align : left;
    background : #EFFFCC;
    color : #000;
}
.my-columnLeft1 {
    text-align : left;
    background : #F5F2DC;
    color : #000;
}
.my-columnRight0 {
    text-align : right;
    background : #EFFFCC;
    color : #000;
}
.my-columnRight1 {
    text-align : right;
    background : #F5F2DC;
    color : #000;
}
</style>


<script type="text/javaScript">

var cdcDs = [];
<c:forEach var="obj" items="${cdcList}">
  cdcDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", address:"${obj.address}", telNo:"${obj.telNo}"});
</c:forEach>

var vendorDs = [];
var vendorObj = {};
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
  vendorObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

// main grid
var mSort = {};

//AUIGrid 생성 후 반환 ID
var myGridID, excelGridId;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"rnum", headerText:"No", visible:false}
            , {dataField:"poMod", visible:false}
            , {
            	headerText:"Purchase Order"
            	, children:[  {dataField:"poStsName", headerText:"Status", width:120
            		            , cellMerge:true
            		            , mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                	if ( "0" == item.poMod ) {
                                		return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
            		        }
			                , {dataField:"poDate", headerText:"PO Date", width:100
			                    , dataType:"date"
			                    , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
			                    , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
			                    , cellMerge:true
			                    , mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                            	, styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
			                }
			                , {dataField:"memAccId", headerText:"Supplier ID", width:120
			                	, cellMerge:true
			                	, mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                            	, styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
			                }
			                , {dataField:"memAccName", headerText:"Supplier Name", width:250
			                	, cellMerge:true
			                	, mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
			                }
			                , {dataField:"poNo", headerText:"PO No", width:120
			                	, cellMerge:true
			                	, styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
			                }
			                , {dataField:"poDtlNo", headerText:"PO Detail No", width:120
			                	, cellMerge:true
			                	, mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
			                }
			                , {dataField:"stockId", visible:false}
				            , {dataField:"stockCode", headerText:"Material Code", width:120
				            	, cellMerge:true
				            	, mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
				            }
				            , {dataField:"stockName", headerText:"Material Name", width:300, style:"aui-grid-user-custom-left"
                                , cellMerge:true
	                            , mergePolicy : "restrict"
	                            , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
				            }
				            , {dataField:"poQty", headerText:"PO QTY", width:100
				                , style:"aui-grid-user-custom-right"
				                , dataType:"numeric"
				                , formatString:"#,##0"
				                , cellMerge:true
				                , mergePolicy : "restrict"
	                            , mergeRef : "poDtlNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
				            }
            	           ]
            }
            , {
                headerText:"Good Issue(Supplier)"
                , children:[  {dataField:"suppStsCd", visible:false}
                            , {dataField:"suppStsCode", visible:false}
                            , {dataField:"suppStsName",headerText :"Sales Order", width:100
                            	, cellMerge:true
                            	, mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"poDtlPlanNo", visible:false}
                            , {dataField:"poPlanQty", headerText:"Plan QTY", width:100
                                , style:"aui-grid-user-custom-right"
                                , dataType:"numeric"
                                , formatString:"#,##0"
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "poDtlPlanNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"poPlanDt", headerText:"Plan Date", width:100
                                , dataType:"date"
                                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"hmcDelvryNo", headerText:"Delivery No", width:140
                            	, cellMerge:true
                            	, mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"hmcDelvryNoDtlNo", headerText:"Delivery No", width:140
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "hmcDelvryNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"delvryQty", headerText:"GI QTY", width:100
                                , style:"aui-grid-user-custom-right"
                                , dataType:"numeric"
                                , formatString:"#,##0"
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "hmcDelvryNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"delvryGiDt", headerText:"GI Date", width:100
                                , dataType:"date"
                                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                           ]
            }
            , {
                headerText:"GR"
                , children:[  {dataField:"hmcGrNo",headerText :"GR No", width:140
                	            , cellMerge:true
                	            , mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                	          }
                            , {dataField:"hmcGrNoDtlNo", headerText:"GR Detail No", width:120
                            	, cellMerge:true
                            	, mergePolicy : "restrict"
                                , mergeRef : "hmcGrNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"grDt", headerText:"GR Date", width:100
                                , dataType:"date"
                                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "poNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"rciptQty", headerText:"GR QTY", width:100
                                , style:"aui-grid-user-custom-right"
                                , dataType:"numeric"
                                , formatString:"#,##0"
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "hmcGrNoDtlNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                            , {dataField:"qcFailQty", headerText:"GR Fail QTY", width:100
                                , style:"aui-grid-user-custom-right"
                                , dataType:"numeric"
                                , formatString:"#,##0"
                                , cellMerge:true
                                , mergePolicy : "restrict"
                                , mergeRef : "hmcGrNoDtlNo"
                                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                    if ( "0" == item.poMod ) {
                                        return  "my-columnCenter0";
                                    } else {
                                        return  "my-columnCenter1";
                                    }
                                }
                            }
                           ]
            }
    ];

    // main 그리드 속성 설정
    var grid_options = {
	      usePaging : false,            // 페이지 설정1
	      //pageRowCount : 30,          // 페이지 설정2
	      //fixedColumnCount : 1,       // 틀고정(index)
	      editable : false,             // 편집 가능 여부 (기본값 : false)
	      enterKeyColumnBase : true,    // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	      selectionMode : "singleRow",  // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
	      //showSelectionBorder:true,   // (녹색 테두리 선)(기본값 : true)
	      //useContextMenu : true,      // 컨텍스트 메뉴 사용 여부 (기본값 : false)
	      showRowNumColumn : false,     // 그리드 넘버링
	      enableFilter : true,          // 필터 사용 여부 (기본값 : false)

	      // 그룹핑 썸머리행의 앞부분에 값을 채울지 여부
          // true 설정하면 그룹핑된 행도 세로 병합이 됨.
	      fillValueGroupingSummary : true,
	      useGroupingPanel : true,     // 그룹핑 패널 사용
	      displayTreeOpen : true,    // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	      // 그룹핑 후 셀 병합 실행
          enableCellMerge : true,
	      // enableCellMerge 할 때 실제로 rowspan 적용 시킬지 여부
          // 만약 false 설정하면 실제 병합은 하지 않고(rowspan 적용 시키지 않고) 최상단에 값만 출력 시킵니다.
          cellMergeRowSpan : false,
          enableCellMerge : true,       // 그룹핑 후 셀 병함 실행
          showBranchOnGrouping : false, // 그룹핑, 셀머지 사용 시 브랜치에 해당되는 행 표시 안함.
          useGroupingPanel : false,     // 그룹핑 패널 사용

	      showStateColumn : false,      // 상태 칼럼 사용
	      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
	      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
	      rowIdField : "rnum",
	      enableSorting : false,
	      showRowCheckColumn : false,      // row 체크박스 표시 설정
	      showRowAllCheckBox : false,      // 전체 체크박스 표시 설정
	      enableRestore: true
    };

    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        excelGridId = GridCommon.createAUIGrid("excelGrid", columnLayout, "", grid_options);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax', rowCount:50});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(excelGridId, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');

        if( js.String.isEmpty($("#sPoDtFrom").val()) ){
            $("#sPoDtFrom").val("${oneMonthBf}");
        }
        if( js.String.isEmpty($("#sPoDtTo").val()) ){
            $("#sPoDtTo").val("${toDay}");
        }

        <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
	        if(js.String.isEmpty("${zMemAccId}")){
	            $("#sMemAcc").val("N");
	        }
	        $("#sMemAccId").val("${zMemAccId}");
	        //$("select[name=sMemAccId]").prop('disabled',true);
	    </c:if>

        // 조회버튼
        $("#btnSearch").click(function(){
            if(js.String.isEmpty($("#sCdc").val()) || js.String.isEmpty($("#sMemAccId").val())){
                Common.alert("Please, check the mandatory value.");
                return ;
            }

		    // 날짜형식 체크
		    var sValidDtFrom = $("#sPoDtFrom").val();
		    var sValidDtTo = $("#sPoDtTo").val();

		    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
		    if( !date_pattern.test(sValidDtFrom)) {
		          Common.alert("Please check the date format.");
		          return ;
		    }
		    if( !date_pattern.test(sValidDtTo)) {
		        Common.alert("Please check the date format.");
		        return ;
		    }

            var arrStDt = sValidDtFrom.split('/');
            var arrEnDt = sValidDtTo.split('/');
            var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
            var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

            var diff = dat2 - dat1;
            if(diff < 0){
            	Common.alert("The start date can be greater than the end date.");
            	return ;
            }

           // if(js.date.dateDiff(dat1, dat2) > 31){
           // 	Common.alert("The duration is only one months.");
           //     return ;
           // }

		    // 메인 그리드 조회
		    getListAjax(1);

          });

        // excel
        $("#excelDown").click(function(){

            if(js.String.isEmpty($("#sCdc").val())){
                Common.alert("Please, check the mandatory value.");
                return ;
            }

            // 날짜형식 체크
            var sValidDtFrom = $("#sPoDtFrom").val();
            var sValidDtTo = $("#sPoDtTo").val();

            var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
            if( !date_pattern.test(sValidDtFrom)) {
                  Common.alert("Please check the date format.");
                  return ;
            }
            if( !date_pattern.test(sValidDtTo)) {
                Common.alert("Please check the date format.");
                return ;
            }

            var arrStDt = sValidDtFrom.split('/');
            var arrEnDt = sValidDtTo.split('/');
            var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
            var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

            var diff = dat2 - dat1;
            if(diff < 0){
                Common.alert("The start date can be greater than the end date.");
                return ;
            }

            //if(js.date.dateDiff(dat1, dat2) > 31){
            //    Common.alert("The duration is only one months.");
            //    return ;
            //}

            var url = "/homecare/report/hcPoStatus/selectHcPoStatusMainExcelList.do";

            var param = $("#searchForm").serializeObject();
            param.sMemAccId = $("#sMemAccId").val();
            console.log("excel param : ", param);

            // 초기화
            AUIGrid.setGridData(excelGridId, []);

            Common.ajax("POST" , url , param, function(data){
                AUIGrid.setGridData(excelGridId, data.dataList);
                GridCommon.exportTo("excelGrid", 'xlsx',"Po Status View");
            });
        });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });
    });

    // 이벤트 정의
    $(function(){

        // header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
        	return false;

            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.
            var cNot = $(myGridID).find(".aui-grid-header-panel").find("tbody > tr > td[colspan]");

            //var span = $(myGridID).find(".aui-grid-header-panel").not(cNot).find("tbody > tr > td > div")[event.columnIndex];
            var span = $(myGridID + " .aui-grid-header-panel tbody > tr > td").not(cNot).find("div")[event.columnIndex];

            if(mSort.hasOwnProperty(event.dataField)){
                if(mSort[event.dataField].dir == "asc"){
                  mSort[event.dataField] = {"field":event.dataField, "dir":"desc" };
                    $(span).removeClass("aui-grid-sorting-ascending");
                    $(span).addClass("aui-grid-sorting-descending");
                }else{
                    delete mSort[event.dataField];
                    $(span).removeClass("aui-grid-sorting-descending");
                }
            }else{
              mSort[event.dataField] = {"field":event.dataField, "dir":"asc"};
                $(span).addClass("aui-grid-sorting-ascending");
            }

            getListAjax(1);
        });

    });


//--function--//

// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/report/hcPoStatus/selectHcPoStatusMainList.do";

    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":50, "goPage":goPage}, {"sort":sortList});
    console.log("param : ", param);

    // 초기화
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param, function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax', rowCount:50});
        AUIGrid.setGridData(myGridID, data.dataList);
    });

}

/**
* dd-mm-yyyy 날짜 형식을 체크함.
*/
function fn_isDateValidate(sValidDt){
  // 날짜형식 체크
    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
    if( sValidDt != null && sValidDt != ""
        && !date_pattern.test(sValidDt)
    ) {
        return false;
    }
    return true;
}

</script>

<section id="content"><!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Homecare</li>
    <li>Report</li>
  </ul>

  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
    <h2>Po Status View</h2>

    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
        </c:if>
    </ul>
  </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><span style="color:red">*</span>CDC</th>
                    <td>
                        <select id="sCdc" name="sCdc" placeholder="" class="w100p" >
                    </td>
                    <th scope="row"><span style="color:red">*</span>PO Date</th>
                    <td>
                        <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="sPoDtFrom" name="sPoDtFrom" type="text"
                                        title="PO start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="sPoDtTo" name="sPoDtTo" type="text"
                                        title="PO End Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div>
                    </td>
                    <th scope="row"><span style="color:red">*</span>Supplier</th>
                    <td>
                        <select id="sMemAccId" name="sMemAccId" title="" placeholder="" class="w100p" >
                        <input type="hidden" id="sMemAcc" name="sMemAcc" />
                    </td>
                </tr>

                <tr>
                    <th scope="row">PO No</th>
                    <td>
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Delivery No</th>
                    <td>
                        <input type="text" id="sHmcDelvryNo" name="sHmcDelvryNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Material</th>
                    <td>
                        <input type="text" id="sStockCode" name="sStockCode" placeholder="" class="w100p" >
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

  <section class="search_result"><!-- search_result start -->
	<aside class="title_line"><!-- title_line start -->
        <h3>PO List</h3>
	    <ul class="right_btns">
	       <li><p class="btn_grid"><a id="excelDown"><spring:message code='sys.btn.excel.dw' /></a></p></li>
	    </ul>
	</aside><!-- title_line end -->

    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!-- 그리드 영역1 -->
        <div id="mainGrid" class="autoGridHeight"></div>

	    <!-- 그리드 페이징 네비게이터 -->
	    <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel autoFixArea"></div>
    </article><!-- grid_wrap end -->

    <div id="excelGrid" style="display:none"></div>
  </section><!-- search_result end -->

</section><!-- content end -->
