<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

</style>

<script type="text/javaScript">

var oldPoNo = -1;
var mSort = {};

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

var poTypeDs = [];
var poTypeObj = {};
<c:forEach var="obj" items="${poTypeList}">
  poTypeDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poTypeObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var poStatDs = [];
var poStatObj = {};
<c:forEach var="obj" items="${poStatList}">
  poStatDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poStatObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var suppStsDs = [];
<c:forEach var="obj" items="${suppStsList}">
  suppStsDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var uomDs = [];
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var curDs = [];
var curObj = {};
<c:forEach var="obj" items="${curList}">
  curDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  curObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var taxDs = [];
var taxObj = {};
<c:forEach var="obj" items="${taxList}">
  taxDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  taxObj["${obj.codeId}"] = {codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"};
</c:forEach>

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"cdc", headerText :"CDC", width:100, editable:false}
            , {dataField:"cdcText",headerText :"CDC Name", width:250, style:"aui-grid-user-custom-left"}
            , {dataField:"poNo",headerText :"Po No", width:160, editable:false}
            , {dataField:"poTyCd", headerText:"Po Type", width:120
                  ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                	    return poTypeObj[value]==null?"":js.String.strNvl(poTypeObj[value]);
                   }
            }
            , {dataField:"poStsCode", visible:false}
            , {dataField:"poStsName",headerText :"Status", width:100, editable:false}
            , {dataField:"suppStsCode", visible:false}
            , {dataField:"suppStsName",headerText :"Sales Order", width:100, editable:false}
            , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, editable:false}
            , {dataField:"apprDt", headerText:"PO Date", width:100, editable:false
            	, dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"cdcDueDt", headerText:"Delivery Due Date", width:140
            	, dataType:"date"
            	, dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"address", headerText:"Delivery Address", width:340, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"tel", headerText:"PIC Contact No", width:140, editable:false}
            , {dataField:"rm", headerText:"Remark", width:300, style:"aui-grid-user-custom-left"}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 0,        // 틀고정(index)
      editable : false,            // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //showSelectionBorder:true,    // (녹색 테두리 선)(기본값 : true)
      //useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : true,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      //useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      //rowIdField : "poNo",
      enableSorting : false,

      showRowCheckColumn : true,      // row 체크박스 표시 설정
      independentAllCheckBox : true,  // 전체 선택 체크박스가 독립적인 역할을 할지 여부
      showRowAllCheckBox : true,      // 전체 체크박스 표시 설정

      enableRestore: true,
      softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제

      // 엑스트라 체크박스 disabled 함수
      // 이 함수는 렌더링 시 빈번히 호출됩니다. 무리한 DOM 작업 하지 마십시오. (성능에 영향을 미침)
      // rowCheckDisabledFunction 이 아래와 같이 간단한 로직이라면, 실제로 rowCheckableFunction 정의가 필요 없습니다.
      // rowCheckDisabledFunction 으로 비활성화된 체크박스는 체크 반응이 일어나지 않습니다.(rowCheckableFunction 불필요)
      rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
          if(item.suppStsCode != "10") { // 10 이 아닌 경우 체크박스 disabeld 처리함
              return false; // false 반환하면 disabled 처리됨
          }
          return true;
      }

    };

    // sub 칼럼 설정
	var subColumnLayout = [{dataField:"poNo", headerText:"PO No", width:160, editable:false}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
              , {dataField:"stockId", visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
              , {dataField:"stockName", headerText:"Material Name", width:300, editable:false, style:"aui-grid-user-custom-left"}
              , {dataField:"poQty", headerText:"PO QTY", width:100
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"confirmQty", headerText:"Confirm QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"uom", headerText:"UOM", width:100, editable:false
            	    ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = "";
                        for(var i=0, len=uomDs.length; i<len; i++) {
                            if(uomDs[i]["codeId"] == value) {
                                retStr = uomDs[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    }
              }
              , {dataField:"poUprc", headerText:"PO Price", width:120
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"suplyPrc", headerText:"Supply Price", width:140
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"tax", headerText:"Tax", width:120
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"taxCd", headerText:"Tax Text", width:100
                  , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                      return taxObj[value]==null?"":js.String.strNvl(taxObj[value].codeName);
                   }
              }
              , {dataField:"total", headerText:"Total", width:140, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"cur", headerText:"Currency", width:120
            	  , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                      return curObj[value]==null?"":js.String.strNvl(curObj[value]);
                   }
              }
              , {dataField:"frexAmt", headerText:"Fx Price", width:120
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
	];

    // sub 그리드 속성 설정
    var subGrid_options = {
		usePaging : false,           // 페이지 설정1
		//pageRowCount : 30,         // 페이지 설정2
		fixedColumnCount : 0,        // 틀고정(index)
		editable : false,             // 편집 가능 여부 (기본값 : false)
		enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
		selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
		useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
		showRowNumColumn : true,     // 그리드 넘버링
		enableFilter : true,         // 필터 사용 여부 (기본값 : false)
		useGroupingPanel : false,    // 그룹핑 패널 사용
		displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
		showStateColumn : false,      // 상태 칼럼 사용
		noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
		groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
		//rowIdField : "priceSeqNo",
		enableSorting : true,
		showFooter : true,
		showRowCheckColumn : false,    // row checkbox
		enableRestore: true,
		softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    // 푸터 설정
    var subFooterLayout = [{labelText : "Total", positionField : "stockName"}
                      , {dataField : "poQty"
                          , positionField : "poQty"
                          , operation : "SUM"
                          , formatString : "#,##0"
                          , style:"aui-grid-user-custom-right"
                      }
                      , {dataField : "confirmQty"
                          , positionField : "confirmQty"
                          , operation : "SUM"
                          , formatString : "#,##0"
                          , style:"aui-grid-user-custom-right"
                      }
                      , {dataField : "poUprc"
                          , positionField : "poUprc"
                          , operation : "SUM"
                          , formatString : "#,##0.00"
                          , style:"aui-grid-user-custom-right"
                      }
                      , {dataField : "suplyPrc"
                          , positionField : "suplyPrc"
                          , operation : "SUM"
                          , formatString : "#,##0.00"
                          , style:"aui-grid-user-custom-right"
                      }
                      , {dataField : "total"
                          , positionField : "total"
                          , operation : "SUM"
                          , formatString : "#,##0.00"
                          , style:"aui-grid-user-custom-right"
                      }
                      , {dataField : "frexAmt"
                          , positionField : "frexAmt"
                          , operation : "SUM"
                          , formatString : "#,##0.00"
                          , style:"aui-grid-user-custom-right"
                      }
   ];

    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        detailGridID = GridCommon.createAUIGrid("subGrid", subColumnLayout,"", subGrid_options);

        // 푸터 레이아웃 세팅
        AUIGrid.setFooter(detailGridID, subFooterLayout);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');
        doDefCombo(poTypeDs, '', 'sPoTyCd', 'S', '');
        doDefCombo(suppStsDs, '', 'sSuppStsCd', 'S', '');

        <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
            if(js.String.isEmpty("${zMemAccId}")){
            	$("#sMemAcc").val("N");
            }
            $("#sMemAccId").val("${zMemAccId}");
	        //$("select[name=sMemAccId]").prop('disabled',true);
        </c:if>

        if( js.String.isEmpty($("#sPoDtFrom").val()) ){
            $("#sPoDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sPoDtTo").val()) ){
            $("#sPoDtTo").val("${toDay}");
        }

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

			// 메인 그리드 조회
			getListAjax(1);

	    });

        // Approval
        $("#btnApproval").click(function(){
        	//fn_multiButton("20");

        	var items = AUIGrid.getCheckedRowItems(myGridID);
            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var isValid = true;
            $.each(items, function(idx, row){
                if(Number(row.item.suppStsCode) != 10){
                    isValid = false;
                }
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }

            $("#editTitle").html("Approve");
            $("#editBody").html("Approve Reason");
            $("#btnPopSave").html("Approve");
            $("#popGubun").val("20");
            $("#rsn").val("");
            $("#editWindow").show();
        });

        // Denial
        $("#btnDenial").click(function(){
        	//fn_multiButton("30");

            var items = AUIGrid.getCheckedRowItems(myGridID);
            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var isValid = true;
            $.each(items, function(idx, row){
                if(Number(row.item.suppStsCode) != 10){
                    isValid = false;
                }
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }

            $("#editTitle").html("Reject");
            $("#editBody").html("Reject Reason");
            $("#btnPopSave").html("Reject");
            $("#popGubun").val("30");
            $("#rsn").val("");
            $("#editWindow").show();
        });

        $("#btnPopSave").click(function(){
        	fn_multiButton($("#popGubun").val());
        });

        $("a[name=btnPopClose]").click(function(){
            $("#editWindow").hide();
        });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });

    });


    // 이벤트 정의
    $(function(){

        /*
		AUIGrid.bind(myGridID, "selectionChange", function( event ) {
            var selectedItems = event.selectedItems;
        });
        */


        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", function( event ) {
        	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        	//var gSelRowIdx = event.rowIndex;

            // 그리드 선택 block을 잡아준다.
        	//AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
            var poNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 2);
            if(poNo != oldPoNo){
	            AUIGrid.setGridData(detailGridID, []);
	            if(js.String.isEmpty(poNo)){
	            	oldPoNo = poNo;
	            	return false;
	            }

	            var subParam = {"sPoNo":poNo};
	            Common.ajax("GET", "/homecare/po/selectHcConfirmPoSubList.do"
	                    , subParam
	                    , function(result){
	                           console.log("data : " + result);
	                           AUIGrid.setGridData(detailGridID, result.dataList);
	            });

            }
            oldPoNo = poNo;
        });

        // header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(myGridID).find(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
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

        // 전체 체크박스 클릭 이벤트 바인딩 - 엑스트라 체크
        AUIGrid.bind(myGridID, "rowAllChkClick", function( event ) {
            if(event.checked) {
                // suppStsCode 의 값들 얻기
                var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "suppStsCode");

                // 20 코드 제거하기
                if(uniqueValues.indexOf("20") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("20"),1);
                }
                // 30 코드 제거하기
                if(uniqueValues.indexOf("30") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("30"),1);
                }

                AUIGrid.setCheckedRowsByValue(event.pid, "suppStsCode", uniqueValues);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "suppStsCode", []);
            }
        });

    });


//--function--//

// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/selectHcConfirmPoMainList.do";
    //var param = $("#searchForm").serialize();
    //param += "&sMemAccId="+$("#sMemAccId").val();
    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    console.log("param : ", param);

    // 초기화
    oldPoNo = -1;
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param , function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
        AUIGrid.setGridData(detailGridID, []);
    });
}

function fn_multiButton(stat){
    var items = AUIGrid.getCheckedRowItems(myGridID);

    if(items.length < 1){
        Common.alert("Please, select a row.");
        return false;
    }

    var isValid = true;
    var mainList = [];
    $.each(items, function(idx, row){
        if(Number(row.item.suppStsCode) != 10){
            isValid = false;
        }else{
            mainList.push(row.item);
        }
    });
    if(!isValid){
        Common.alert("Please, check the status.");
        return false;
    }
    //var message = stat == "20"?"Do you want to approve?":"Do you want to Reject?";
    var params = {"mainData":mainList, "statCd":stat, "rsn":$("#rsn").val()};

    Common.ajax("POST", "/homecare/po/multiConfirmPo.do"
            , params
            , function(result){
                $("#editWindow").hide();
                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                $("#btnSearch").click();

                //getListAjax(1);
                //console.log("성공." + JSON.stringify(result));
                //console.log("data : " + result.data);
             }
            , function(jqXHR, textStatus, errorThrown){
                try{
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                }catch (e){
                    console.log(e);
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);
    });


}

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Homecare</li>
        <li>PO</li>
        <li>POManager</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
        <h2>PO Confirmation</h2>

        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		        <li><p class="btn_blue"><a id="btnApproval">Approve</a></p></li>
		        <li><p class="btn_blue"><a id="btnDenial">Reject</a></p></li>
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
                    <th scope="row">PO Type</th>
                    <td >
                        <select id="sPoTyCd" name="sPoTyCd" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Sales Order</th>
                    <td >
                        <select id="sSuppStsCd" name="sSuppStsCd" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">PO No</th>
                    <td >
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

    <!-- data body start -->
  <section class="search_result"><!-- search_result start -->
	<aside class="title_line"><!-- title_line start -->
	</aside><!-- title_line end -->
	<!-- grid_wrap start -->
	<article class="grid_wrap">
	   <!-- 그리드 영역1 -->
	   <div id="mainGrid" style="height:320px;"></div>

	   <!-- 그리드 페이징 네비게이터 -->
       <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</article>
	<!-- grid_wrap end -->

	<aside class="title_line"><!-- title_line start -->
	</aside><!-- title_line end -->
	<article class="grid_wrap" ><!-- grid_wrap start -->
	  <!--  그리드 영역2  -->
	  <div id="subGrid" class="autoGridHeight"></div>
	</article><!-- grid_wrap end -->
  </section><!-- data body end -->


  <div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
       <h1 id="editTitle">Approve</h1>
       <ul class="right_opt">
            <li><p class="btn_blue2"><a name="btnPopClose">CLOSE</a></p></li>
       </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
    <form id="insForm" name="insForm" method="POST">
        <input type="hidden" id="popGubun">
        <table class="type1"><!-- table start -->
          <caption>remark table</caption>
          <colgroup>
            <col style="width:120px" />
            <col style="width:*" />
          </colgroup>
          <tbody>
              <tr>
                  <th scope="row" id="editBody">Confirmation Reason</th>
                  <td >
                      <textarea rows="5" cols="20" maxlength="100" id="rsn" name="rsn" placeholder="Remark"></textarea>
                  </td>
              </tr>
          </tbody>
        </table><!-- table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a id="btnPopSave">SAVE</a></p></li>
            <li><p class="btn_blue2 big"><a name="btnPopClose">CLOSE</a></p></li>
        </ul>
    </form>
    </section>
  </div>

</section><!-- content end -->
