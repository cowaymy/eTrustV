<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
 text-align: left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
 color: #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
 background: #D9E5FF;
 color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
 background: #D9E5FF;
 color: #000;
}

.my-row-style-success {
    background:#b9f6ca;
    font-weight:bold;
    color:#22741C;
}

.my-row-style {
    background:#FFB6C1;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
	// AUIGrid 생성 후 반환 ID
	var myGridID, uploadGrid, enabledRowIDs = [];

	// AUIGrid 칼럼 설정                                                                            visible : false
	//initial grid
	var columnLayout = [ {
        dataField : "tierUploadId",
        headerText : "<spring:message code='sales.text.tierID'/>",
        width : "10%",
        height : 30,
        visible : true
    }, {
        dataField : "tierTotalRecord",
        headerText : "<spring:message code='pay.head.totalRecords'/>",
        width : "10%",
        height : 30,
        visible : true
    }, {
        dataField : "name",
        headerText : "<spring:message code='sales.Status'/>",
        width : "20%",
        height : 30,
        visible : true
    }, {
        dataField : "userFullName",
        headerText : "<spring:message code='sal.text.creator'/>",
        width : "20%",
        height : 30,
        visible : true
    }, {
        dataField : "tierUploadCrtDt",
        headerText : "<spring:message code='sales.CreateDate'/>",
        width : "25%",
        height : 30,
        visible : true
    }, {
        dataField : "tierUploadCrtDt",
        headerText : "<spring:message code='sales.CreateDate'/>",
        width : "13%",
        height : 30,
        visible : true
    } ];

	//search grid
	var columnPointItemLayout = [ {
		dataField : "tierUploadDetId",
		headerText : "<spring:message code='sales.text.tierDetID'/>",
		width : "7%",
		height : 30,
		visible : true
	}, {
		dataField : "tierCustNric",
		headerText : "<spring:message code='service.title.CustomerNRIC'/>",
		width : "20%",
		height : 30,
		visible : true
	}, {
		dataField : "code",
		headerText : "<spring:message code='sales.text.rewardType'/>",
		width : "13%",
		height : 30,
		visible : true
	}, {
        dataField : "remark",
        headerText : "<spring:message code='sales.Remark'/>",
        width : "20%",
        height : 30,
        visible : true
    }, {
		dataField : "rewPoint",
		headerText : "<spring:message code='sales.text.rewardPoint'/>",
		width : "13%",
		height : 30,
		visible : true
	}, {
		dataField : "name",
		headerText : "<spring:message code='sales.Status'/>",
		width : "10%",
		height : 30,
		visible : true
	}, {
		dataField : "userName",
		headerText : "<spring:message code='sal.text.creator'/>",
		width : "10%",
		height : 30,
		visible : true
	}, {
		dataField : "tierUploadCrtDt",
		headerText : "<spring:message code='sales.CreateDate'/>",
		width : "13%",
		height : 30,
		visible : true
	} ];

	var updResultColLayout = [ {
		dataField : "0",
		headerText : "msisdn",
		editable : true
	}, {
		dataField : "1",
		headerText : "orderNo",
		editable : true
	}, {
		dataField : "2",
		headerText : "message",
		editable : true
	} ];

	var uploadGridLayout = [ {
		dataField : "0",
		headerText : "<spring:message code='service.title.CustomerNRIC'/>",
		width : "25%",
		editable : true
	}, {
		dataField : "1",
		headerText : "<spring:message code='sales.text.rewardType'/>",
		width : "25%",
		editable : true
	}, {
		dataField : "2",
		headerText : "<spring:message code='sales.Remark'/>",
		width : "37%",
		editable : true
	}, {
		dataField : "3",
		headerText : "<spring:message code='sales.text.rewardPoint'/>",
		width : "15%",
		editable : true
	} ];
	/* 그리드 속성 설정
	 usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
	 editable : false,// 편집 가능 여부 (기본값 : false)
	 enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	 selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)
	 useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)
	 enableFilter : true,// 필터 사용 여부 (기본값 : false)
	 useGroupingPanel : true,// 그룹핑 패널 사용
	 showStateColumn : true,// 상태 칼럼 사용
	 displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	 noDataMessage : "출력할 데이터가 없습니다.",
	 groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
	 rowIdField : "stkid",
	 enableSorting : true,
	 showRowCheckColumn : true,
	 */
	var gridoptions = {
		showStateColumn : false,
		showRowCheckColumn : true,
		independentAllCheckBox : true,
		showRowAllCheckBox : false,
		rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
	          if(item.tierUploadStusId != 59) { // 10 이 아닌 경우 체크박스 disabeld 처리함
	              return false; // false 반환하면 disabled 처리됨
	          }
	          return true;
	    },
		editable : false,
		pageRowCount : 30,
		usePaging : true,
		useGroupingPanel : false,
		wordWrap : true,
        // row Styling 함수
        rowStyleFunction : function(rowIndex, item) {
        	//failed status
            if(item.tierDetStusId == 21 || item.tierUploadStusId == 21) {
                return "my-row-style";
            }
            //completed status
            else if(item.tierDetStusId == 4 || item.tierUploadStusId == 4) {
            	return "my-row-style-success";
            }
            else {
            	//if status is  "Wait for Approve"
            	if(item.tierUploadStusId == 59){
            		   enabledRowIDs.push(item.tierUploadId);
            	}
                return "";
            }
        }
	};

	var gridPros = {
		editable : false, // 편집 가능 여부 (기본값 : false)
		showStateColumn : false, // 상태 칼럼 사용
		softRemoveRowMode : false
	};

	hideViewPopup = function(val) {
		$(val).hide();

		fn_uploadClear();
	}

	function fn_uploadClear(){
	    //화면내 모든 form 객체 초기화
	    $("#updResultForm")[0].reset();

	    AUIGrid.clearGridData(uploadGrid);
	}

	function onlyNumber(obj) {
        $(obj).keyup(function(){
             $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    }

	function gridInfo() {
		// masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap",
                columnLayout, "", gridoptions);

        //Only check the rows that is not failed
        AUIGrid.bind(myGridID, "rowAllChkClick", function( event ) {
            if(event.checked) {
                AUIGrid.setCheckedRowsByValue(event.pid, "tierUploadId", enabledRowIDs);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "tierUploadId", []);
            }
        });

        //search grid
        gridoptions.showRowCheckColumn = false;
        pointGrid = GridCommon.createAUIGrid(
                "#pointDetails_grid_wrap", columnPointItemLayout,
                null, gridoptions);

        var gridPros3 = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 35,
            softRemoveRowMode : false
        }
        uploadGrid = GridCommon.createAUIGrid(
                "#grid_upload_wrap", uploadGridLayout, null,
                gridPros3);

     // 셀 더블클릭 이벤트 바인딩
        AUIGrid
                .bind(
                        myGridID,
                        "cellDoubleClick",
                        function(event) {
                            var pointUploadId = AUIGrid
                                    .getCellValue(myGridID,
                                            event.rowIndex,
                                            "tierUploadId");
                            var url = "/sales/customer/selectRewardBulkPointItem.do";

                            Common
                                    .ajax(
                                            "GET",
                                            url,
                                            {
                                                pointUploadId : pointUploadId
                                            },
                                            function(result) {
                                                console.log(result);
                                                $("#view_wrap")
                                                        .show();
                                                $(
                                                        "#view_tierId")
                                                .text(
                                                        pointUploadId);
                                                $(
                                                        "#view_totalRecord")
                                                        .text(
                                                                result.mst.tierTotalRecord);
                                                $(
                                                        "#view_crtUsr")
                                                        .text(
                                                                result.mst.userFullName);
                                                $("#view_crtDt")
                                                        .text(
                                                                result.mst.tierUploadCrtDt);
                                                AUIGrid
                                                        .setGridData(
                                                                pointGrid,
                                                                result.details);


                                                AUIGrid
                                                        .resize(
                                                                pointGrid,
                                                                945,
                                                                $(
                                                                        ".grid_wrap")
                                                                        .innerHeight());

                                            });
                        });
	}

	$(document)
			.ready(
					function() {
						gridInfo();

						$('#fileSelector')
								.on(
										'change',
										function(evt) {
											if (!checkHTML5Brower()) {
												// 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
												// 파일 내용 읽어 반환시켜 그리드에 적용.
												commitFormSubmit();

												//alert("브라우저가 HTML5 를 지원하지 않습니다.");
											} else {
												var data = null;
												var file = evt.target.files[0];
												if (typeof file == "undefined") {
													return;
												}

												var reader = new FileReader();
												//reader.readAsText(file); // 파일 내용 읽기
												reader.readAsText(file,
														"EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
												reader.onload = function(event) {
													if (typeof event.target.result != "undefined") {
														// 그리드 CSV 데이터 적용시킴
														AUIGrid
																.setCsvGridData(
																		uploadGrid,
																		event.target.result,
																		false);

														//csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
														AUIGrid.removeRow(
																uploadGrid, 0);
													} else {
														Common
																.alert("<spring:message code='pay.alert.noData'/>");
													}
												};

												reader.onerror = function() {
													Common
															.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
												};
											}

										});

						/* 팝업 드래그 start */
						$("#popup_wrap, .popup_wrap").draggable({
							handle : '.pop_header'
						});
						/* 팝업 드래그 end */

						// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
						function checkHTML5Brower() {
							var isCompatible = false;
							if (window.File && window.FileReader
									&& window.FileList && window.Blob) {
								isCompatible = true;
							}
							return isCompatible;
						};


						//HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
						//서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
						//즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
						function commitFormSubmit() {

							AUIGrid.showAjaxLoader(uploadGrid);

							// Submit 을 AJax 로 보내고 받음.
							// ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
							// 링크 : http://malsup.com/jquery/form/
							$('#updResultForm')
									.ajaxSubmit(
											{
												type : "json",
												success : function(
														responseText,
														statusText) {
													if (responseText != "error") {
														var csvText = responseText;

														// 기본 개행은 \r\n 으로 구분합니다.
														// Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
														// 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
														// 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함.
														csvText = csvText
																.replace(
																		/\r?\n/g,
																		"\r\n")

														// 그리드 CSV 데이터 적용시킴
														AUIGrid.setCsvGridData(
																uploadGrid,
																csvText);
														AUIGrid
																.removeAjaxLoader(uploadGrid);

														//csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
														AUIGrid.removeRow(
																uploadGrid, 0);
													}
												},
												error : function(e) {
													Common
															.alert("ajaxSubmit Error : "
																	+ e);
												}
											});
						}
					});

	function f_multiCombo() {
		$(function() {
			$('#cmbStatus').change(function() {
			}).multipleSelect({
				selectAll : true, // 전체선택
				width : '80%'
			}).multipleSelect("checkAll");
		});
	}

	$(function() {
		$("#search").click(function() {
			getBulkPointListAjax();
		});

		$("#bulkPointUpload").click(function() {
			$("#pointBatchReq_wrap").show();
			AUIGrid.resize(uploadGrid);
		});

		$("#bulkPointConfirm").click(function() {
			enabledRowIDs = [];
            var items = AUIGrid.getCheckedRowItems(myGridID);

            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var isValid = true;
            $.each(items, function(idx, row){
                if(Number(row.item.tierUploadStusId) != 59){
                    isValid = false;
                    return;
                }
                enabledRowIDs.push(row.item.tierUploadId);
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }
            Common.confirm("Are you sure want to confirm this?",
                    function(){
            	console.log(enabledRowIDs);
            	var tierUploadId = "";

            	for (var i = 0; i < enabledRowIDs.length; i++) {
            		tierUploadId += "tierUploadId=" + enabledRowIDs[i];

            	  if (i !== enabledRowIDs.length - 1) {
            		  tierUploadId += "&";
            	  }
            	}

            	console.log(tierUploadId);
                    	Common.ajax("GET","/sales/customer/confirmRewardBulkPoint.do", tierUploadId, function(result){
                    		console.log(result.message);
                            Common.alert(result.message.message);



                            $("#search").click();
                         });
                  	});
        });
	});

	function getBulkPointListAjax() {
		Common.ajax("GET", "/sales/customer/selectRewardBulkPointList.do", $(
				'#SearchForm').serialize(), function(result) {
			AUIGrid.setGridData(myGridID, result.data);
			console.log(result.data);
		});
	}

	function fn_resultFileUp() {
		//param data array
		var data = {};
		var gridList = AUIGrid.getGridData(uploadGrid);

		//array에 담기
		if (gridList.length > 0) {
			data.all = gridList;
		} else {
			alert('Select the CSV file on the local PC');
			return;
		}

		var formData = new FormData();
		formData.append("csvFile", $("input[name=fileSelector]")[0].files[0]);
		if(!fn_validation()){
			return;
		}
		//Ajax 호출

		Common.confirm("Are you sure want to upload this?",
		function(){
			Common
            .ajaxFile(
                    "/sales/customer/uploadRewardBulkPoint.do",
                    formData,
                    function(result) {
                        Common.alert(result.message, function (){
                              hideViewPopup('#pointBatchReq_wrap');
                              $("#search").click();
                        });
                    }, function(jqXHR, textStatus, errorThrown) {
                        try {
                            console.log("status : " + jqXHR.status);
                            console
                                    .log("code : "
                                            + jqXHR.responseJSON.code);
                            console.log("message : "
                                    + jqXHR.responseJSON.message);
                            console.log("detailMessage : "
                                    + jqXHR.responseJSON.detailMessage);
                        } catch (e) {
                            console.log(e);
                        }
                        alert("Fail : " + jqXHR.responseJSON.message);
                    });
		});
	}

	function fn_checkMandatory(objValue) {

		if (objValue == null || objValue == "" || objValue == "undefined") {
			return true;
		}
	}

	function fn_validation() {

		var data = GridCommon.getGridData(uploadGrid);

		var length = data.all.length;

		if (length < 1) {
			Common
					.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
			return false;
		}

		if (length > 0) {
			for (var i = 0; i < length - 1; i++) {
				console.log("AUIGrid.getCellValue(uploadGrid, i, 0 "
						+ fn_checkMandatory((AUIGrid.getCellValue(uploadGrid,
								i, "0"))));
				if (fn_checkMandatory((AUIGrid.getCellValue(uploadGrid, i, "0")))) {
					var text = '<spring:message code="service.title.CustomerNRIC"/>';
					Common.alert(text + " is mandatory.");
					return false;
				}
				if (fn_checkMandatory((AUIGrid.getCellValue(uploadGrid, i, "1")))) {
					var text = '<spring:message code="sales.text.rewardType"/>';
					Common.alert(text + " is mandatory.");
					return false;
				}
				if (fn_checkMandatory((AUIGrid.getCellValue(uploadGrid, i, "3")))) {
					var text = '<spring:message code="sales.text.rewardPoint"/>';
					Common.alert(text + " is mandatory.");
					return false;
				}
			}

		}
		return true;
	}
</script>
</head>
<body>
  <section id="content">
    <!-- content start -->
    <ul class="path">
      <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
      <li>Customer</li>
      <li>Bulk Point Upload</li>
    </ul>
    <aside class="title_line">
      <!-- title_line start -->
      <p class="fav">
        <a href="#" class="click_add_on">My menu</a>
      </p>
      <h2>Bulk Point Upload</h2>
      <ul class="right_btns">
        <li>
            <p class="btn_blue">
                <a id="search"><span class="search"></span>Search</a>
            </p>
        </li>
        <li><p class="btn_blue">
            <a id="clear"><span class="clear"></span>Clear</a>
          </p></li>
      </ul>
    </aside>
    <!-- title_line end -->
    <section class="search_table">
      <!-- search_table start -->
      <form id="SearchForm" name="SearchForm" method="post">
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='sales.text.tierID' /></th>
              <td><input type="text" id="searchTierId" name="searchTierId" title="" placeholder="Tier Upload ID (Number Only)" class="w100p" onkeydown="onlyNumber(this)" /></td>
              <th scope="row"><spring:message code='service.title.Status' /></th>
              <td><select id="searchPointStatus" name="searchPointStatus" class="multy_select w100p" multiple="multiple">
                  <option value="1">Active</option>
                  <option value="4">Completed</option>
                  <option value="5">Approved</option>
                  <option value="59">Wait For Approve</option>
                  <option value="8">Inactive</option>
                  <option value="21">Failed</option>
              </select></td>
            </tr>
            <tr>
              <th scope="row">Create Date</th>
              <td>
                <div class="date_set w100p">
                  <!-- date_set start -->
                  <p>
                    <input id="searchCrtStartDt" name="searchCrtStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
                  </p>
                  <span>To</span>
                  <p>
                    <input id="searchCrtEndDt" name="searchCrtEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
                  </p>
                </div> <!-- date_set end -->
              </td>
              <th scope="row">Create User</th>
              <td><input type="text" id="searchCreateUser" name="searchCreateUser" title="" placeholder="Create User" class="w100p" /></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </form>
    </section>
    <!-- search_table end -->
    <section class="search_result">
      <!-- search_result start -->
      <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_grid">
            <a id="bulkPointUpload">Bulk Point Upload</a>
          </p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="btn_grid">
            <a id="bulkPointConfirm">Confirm Bulk Point</a>
          </p></li>
        </c:if>

      </ul>
      <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="grid_wrap"></div>
      </article>
      <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <!-------------------------------------------------------------------------------------
    POP-UP (BULK POINT VIEW)
-------------------------------------------------------------------------------------->
    <!-- popup_wrap start -->
    <div class="popup_wrap" id="view_wrap" style="display: none;">
      <!-- pop_header start -->
      <header class="pop_header" id="pop_header">
        <h1>Bulk Point Detail</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2">
              <a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
            </p></li>
        </ul>
      </header>
      <!-- pop_header end -->
      <!-- pop_body start -->
      <section class="pop_body">
        <!-- table start -->
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 165px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row">Tier Upload ID</th>
              <td id="view_tierId"></td>
              <th scope="row">Total Record</th>
              <td id="view_totalRecord"></td>
            </tr>
            <tr>
              <th scope="row">Create Date</th>
              <td id="view_crtDt"></td>
              <th scope="row">Create User</th>
              <td id="view_crtUsr"></td>
            </tr>
          </tbody>
        </table>
        </article>
        <!-- #########SMS Content######### -->
        <!-- table start -->
        <!-- grid_wrap start -->
        <table class="type1">
          <caption>table</caption>
          <tbody>
            <tr>
              <td colspan='5'>
                <div id="pointDetails_grid_wrap" style="width: 100%;
 height: 480px;
 margin: 0 auto;"></div>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
        <!-- grid_wrap end -->
        <!-- pop_body end -->
    </div>
    <!-- popup_wrap end -->
    <!----------- POP-UP (BULK POINT UPLOAD)-------->
    <!-- popup_wrap start -->
    <div class="popup_wrap" id="pointBatchReq_wrap" style="display: none;">
      <!-- pop_header start -->
      <header class="pop_header" id="pointBatchReq_wrap_pop_header">
        <h1>Point Batch Request</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2">
              <a href="#" onclick="hideViewPopup('#pointBatchReq_wrap')">CLOSE</a>
            </p></li>
        </ul>
      </header>
      <!-- pop_header end -->
      <!-- pop_body start -->
      <form name="updResultForm" id="updResultForm" method="post">
        <section class="pop_body">
          <!-- search_table start -->
          <section class="search_table">
            <!-- table start -->
            <table class="type1">
              <caption>table</caption>
              <colgroup>
                <col style="width: 165px" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Batch File</th>
                  <td>
                    <!-- auto_file start -->
                    <div class="auto_file">
                      <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".csv" />
                    </div> <!-- auto_file end -->
                  </td>
                </tr>
              </tbody>
            </table>
          </section>
          <!-- search_table end -->
          <ul class="center_btns">
            <li><p class="btn_blue2">
                <a href="javascript:fn_resultFileUp();">Upload</a>
              </p></li>
            <li><p class="btn_blue2">
                <a href="${pageContext.request.contextPath}/resources/download/sales/Point_Batch.csv">Download CSV Format</a>
              </p></li>
          </ul>
          <!-- search_result start -->
          <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_upload_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
          </section>
          <!-- search_result end -->
        </section>
      </form>
      <!-- pop_body end -->
    </div>
    <!-- popup_wrap end -->
  </section>
  <!-- content end -->