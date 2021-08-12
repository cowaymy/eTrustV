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

var oldSettlementNo = -1;
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

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [
              {dataField:"settlDt", headerText :"Deposit Date", width:150
            	  , dataType:"date"
                  , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                  , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                  , editRenderer : {
                          type:"CalendarRenderer"
                        , onlyMonthMode:false
                        , showEditorBtnOver:true
                        //, defaultFormat:"dd/mm/yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                        , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                        //, openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                        , onlyNumeric : false // 숫자
                  }
             }
            , {dataField:"poSettlStatus", visible:false}
            , {dataField:"poSettlStatusCd", visible:false}
            , {dataField:"poSettlStatusNm", headerText:"Settlement Status", width:160, editable:false}
            , {dataField:"settlNo", headerText :"Settlement No", width:170, editable:false}
            , {dataField:"hmcGrNo", headerText :"GR No", width:160, editable:false}
            , {dataField:"amount", headerText:"Amount", width:160, editable:false
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0.00"
            }
            , {dataField:"settlementAmount", headerText:"Settlement Amount", width:160, editable:false
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0.00"
            }
            , {dataField:"curNm",headerText :"CUR", width:100, editable:false}

            , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:300, style:"aui-grid-user-custom-left", editable:false}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 0,        // 틀고정(index)
      editable : true,            // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "multipleRows", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
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
          if(js.String.strNvl(item.poSettlStatus) != ""
        		  && js.String.strNvl(item.poSettlStatusCd) != "25") { // null과 Rejected가 아닌 경우 체크박스 disabeld 처리함
              return false; // false 반환하면 disabled 처리됨
          }
          return true;
      }

    };

    // sub 칼럼 설정
	var subColumnLayout = [{dataField:"settlNo", headerText:"Settlement No", width:140}
	          , {dataField:"hmcGrNo", headerText:"GR No", width:140}
              , {dataField:"hmcGrNoDtlNo", headerText:"GR Detail No", width:130}
              , {dataField:"stockId", visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120}
              , {dataField:"stockName", headerText:"Material Name", width:300, style:"aui-grid-user-custom-left"}
              , {dataField:"uomNm", headerText:"UOM", width:100}
              , {dataField:"rciptQty", headerText:"QTY", width:100
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"poUprc", headerText:"PO Price", width:100
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
              , {dataField:"taxNm", headerText:"Tax Text", width:100}
              , {dataField:"total", headerText:"Total", width:140
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"curNm", headerText:"Currency", width:120}
              , {dataField:"poNo", headerText:"PO No", width:160}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:140}
              , {dataField:"hmcDelvryNo", headerText:"Delivery No", width:140}
              , {dataField:"hmcDelvryNoDtlNo", headerText:"Delivery Detail No", width:140}
	];

    // sub 그리드 속성 설정
    var subGrid_options = {
		usePaging : false,           // 페이지 설정1
		//pageRowCount : 30,         // 페이지 설정2
		fixedColumnCount : 0,        // 틀고정(index)
		editable : false,            // 편집 가능 여부 (기본값 : false)
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
		showRowCheckColumn : false,    // row checkbox
		enableRestore: true,
		showFooter : true,
		softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    var subFooterLayout = [{labelText : "Total", positionField : "stockName"}
	    , {dataField : "rciptQty"
	        , positionField : "rciptQty"
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

        if( js.String.isEmpty($("#sGrDtFrom").val()) ){
            $("#sGrDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sGrDtTo").val()) ){
            $("#sGrDtTo").val("${toDay}");
        }

        <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
	        if(js.String.isEmpty("${zMemAccId}")){
	            $("#sMemAcc").val("N");
	        }
	        $("#sMemAccId").val("${zMemAccId}");
	        $("select[name=sMemAccId]").prop('disabled',true);
        </c:if>

        // 조회버튼
	    $("#btnSearch").click(function(){
	        if(js.String.isEmpty($("#sCdc").val())){
			    Common.alert("Please, check the mandatory value.");
			    return ;
			}

			// 날짜형식 체크
			var sValidDtFrom = $("#sGrDtFrom").val();
			var sValidDtTo = $("#sGrDtTo").val();

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

        // SAVE
        $("#btnSave").click(function(){
            var chkList = AUIGrid.getCheckedRowItems(myGridID);
            var udtList = AUIGrid.getEditedRowItems(myGridID);

            if (chkList.length == 0 && udtList.length == 0){
                Common.alert("No Change");
                return false;
            }


            var isValid = true;
            var reqList = [];
            var totAmount = 0;
            $.each(chkList, function(idx, row){
                if(row.item.poSettlStatusCd != "-1" && row.item.poSettlStatusCd != "25" ){
                    isValid = false;
                }else{
                	totAmount += Number(row.item.amount);
                	reqList.push(row.item);
                }
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }

            if(udtList.length > 0){
            	for(var i=0, len=udtList.length; i<len; i++) {
            		if(!isSettlDtCheck(udtList, udtList[i].settlNo, udtList[i].settlDt)){
            			Common.alert("The same Settlement No cannot enter a different Deposit Date.");
            			return false;
            		}
            	}
            }

            var message = "Do you want to Save?";

            var params = {"chkList":reqList, "udtList":udtList, "totAmount":totAmount};

            Common
                .confirm(
                    message,
                    function(){
                        Common.ajax("POST", "/homecare/po/hcSettlement/multiHcSettlement.do"
                                , params
                                , function(result){
                                    Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                                    getListAjax(1);
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
            );

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
        AUIGrid.bind(myGridID, "cellClick", cellClickEvent);

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
                var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "poSettlStatusCd");

                // 10 코드 제거하기
                if(uniqueValues.indexOf("10") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("10"),1);
                }
                // 20 코드 제거하기
                if(uniqueValues.indexOf("20") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("20"),1);
                }
                // 26 코드 제거하기
                if(uniqueValues.indexOf("26") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("26"),1);
                }
                // 30 코드 제거하기
                if(uniqueValues.indexOf("30") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("30"),1);
                }

                AUIGrid.setCheckedRowsByValue(event.pid, "poSettlStatusCd", uniqueValues);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "poSettlStatusCd", []);
            }
        });


        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellEditBegin", function(e){
        	if(e.dataField == "settlDt"){
        	    if(js.String.strNvl(e.item.poSettlStatusCd) != "20" ){
        	    	return false;
        	    }
        	}
        });

        AUIGrid.bind(myGridID, "cellEditEnd", function(e){
            if(e.dataField == "settlDt"){
            	var rows = AUIGrid.getRowIndexesByValue(myGridID, "settlNo", e.item.settlNo);
            	$.each(rows, function(i, row){
            	    AUIGrid.setCellValue(myGridID, row, "settlDt", e.value);
            	});
            }
        });
    });


//--function--//

function cellClickEvent( event ){
	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
	//var gSelRowIdx = event.rowIndex;

	// 그리드 선택 block을 잡아준다.
	//AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
	var settlNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 'settlNo');
	var hmcGrNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 'hmcGrNo');

	if(js.String.isNotEmpty(hmcGrNo) && settlNo != oldSettlementNo){
	    AUIGrid.setGridData(detailGridID, []);
	    if(js.String.isEmpty(settlNo)){
	        oldSettlementNo = settlNo;
	        return false;
	    }

	    var subParam = {"sSettlNo":settlNo};
	    Common.ajax("GET", "/homecare/po/hcSettlement/selectHcSettlementSub.do"
	            , subParam
	            , function(result){
	                   console.log("data : " + result);
	                   AUIGrid.setGridData(detailGridID, result.dataList);
	    });

	}
	oldSettlementNo = settlNo;
}

// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/hcSettlement/selectHcSettlementMain.do";
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
    oldSettlementNo = -1;
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param , function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
        AUIGrid.setGridData(detailGridID, []);

        if(data.total > 0){
            // 행을 선택해줌.
            AUIGrid.setSelectionByIndex(myGridID, 0);
            cellClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });
}



function isSettlDtCheck(list, settlNo, settlDt){
    var isCheck = true;
	for(var i=0, len=list.length; i<len; i++) {
		if(list[i].settlNo == settlNo){
			if(list[i].settlDt != settlDt){
				isCheck = false;
				break;
			}
		}
	}
	return isCheck;
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
        <h2>Settlement</h2>
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_blue"><a id="btnSave">SAVE</a></p></li>
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
                    <th scope="row"><span style="color:red">*</span>GR Date</th>
		            <td>
		                <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="sGrDtFrom" name="sGrDtFrom" type="text"
                                        title="GR start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="sGrDtTo" name="sGrDtTo" type="text"
                                        title="GR End Date" placeholder="DD/MM/YYYY" class="j_date">
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
                    <th scope="row">GR No</th>
                    <td >
                        <input type="text" id="sHmcGrNo" name="sHmcGrNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Settlement No</th>
                    <td >
                        <input type="text" id="sSettlNo" name="sSettlNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row"></th>
                    <td ></td>
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

</section><!-- content end -->
