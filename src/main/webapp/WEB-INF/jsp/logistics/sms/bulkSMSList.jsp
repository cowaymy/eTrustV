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


    // AUIGrid 생성 후 반환 ID
    var myGridID,updResultGridID,smsGrid;
    var comboStatusCode = [{"codeId": "44","codeName": "Pending"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

    // AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [
{dataField: "smsUploadId",headerText :"<spring:message code='log.head.smsid'/>"              ,width:  "5%"     ,height:30 , visible:false},
{dataField: "smsUploadRefNo",headerText :"<spring:message code='log.head.refno'/>"     ,width: "20%"    ,height:30 , visible:true},
{dataField: "totalSms",headerText :"<spring:message code='log.head.status'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsExprDt",headerText :"<spring:message code='log.head.exprDt'/>"     ,width: "25%"    ,height:30 , visible:true},
{dataField: "userFullName",headerText :"<spring:message code='log.head.creator'/>"     ,width: "20%"    ,height:30 , visible:true},
{dataField: "smsUploadCrtDt",headerText :"<spring:message code='log.head.createdate'/>"     ,width: "25%"    ,height:30 , visible:true}
                       ];

var columnSmsItemLayout = [
{dataField: "smsId",headerText :"<spring:message code='log.head.smsid'/>"              ,width:  "7%"     ,height:30 , visible:false},
{dataField: "smsMsisdn",headerText :"<spring:message code='log.head.msisdn'/>"              ,width:  "10%"     ,height:30 , visible:true},
{dataField: "smsMsg",headerText :"<spring:message code='log.head.msg'/>"               ,width:  "40%"    ,height:30 , visible:true},
{dataField: "smsRefNo",headerText :"<spring:message code='log.head.refno'/>"     ,width: "8%"    ,height:30 , visible:true},
{dataField: "smsStatusCode",headerText :"<spring:message code='log.head.status'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsExprDt",headerText :"<spring:message code='log.head.exprDt'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsRetry",headerText :"<spring:message code='log.head.retry'/>"     ,width: "5%"    ,height:30 , visible:true},
{dataField: "userName",headerText :"<spring:message code='log.head.creator'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsCrtDt",headerText :"<spring:message code='log.head.createdate'/>"     ,width: "10%"    ,height:30 , visible:true}
];

var updResultColLayout = [
                          {dataField : "0",headerText : "msisdn", editable : true},
                          {dataField : "1",headerText : "orderNo",editable : true},
                          {dataField : "2",headerText : "message",editable : true}
                          ];
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
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false, wordWrap : true };

    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            softRemoveRowMode:false
    };


    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        updResultGridID = GridCommon.createAUIGrid("updResult_grid_wrap", updResultColLayout,null,gridPros);
        smsGrid = GridCommon.createAUIGrid("#smsDetails_grid_wrap", columnSmsItemLayout,null,gridoptions);

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
        {
        	var smsUploadId = AUIGrid.getCellValue(myGridID, event.rowIndex, "smsUploadId");
        	 Common.ajax("GET", "/logistics/sms/selectBulkSmsItem.do",{smsUploadId : smsUploadId} , function(result) {
        		 $("#view_wrap").show();
        		 $("#view_refNo").text(result.mst.smsUploadRefNo);
                 $("#view_totalSms").text(result.mst.totalSms);
                 $("#view_crtUsr").text(result.mst.userFullName);
                 $("#view_crtDt").text(result.mst.smsUploadCrtDt);
                 $("#view_exprDt").text(result.mst.smsExprDt);

                 AUIGrid.setGridData(smsGrid, result.details);
                 AUIGrid.resize(smsGrid,945, $(".grid_wrap").innerHeight());

             });
        });

        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */

     // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
        function checkHTML5Brower() {
            var isCompatible = false;
            if (window.File && window.FileReader && window.FileList && window.Blob) {
                isCompatible = true;
            }
            return isCompatible;
        };

        $('#fileSelector').on('change', function(evt) {
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
                reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
                reader.onload = function(event) {
                    if (typeof event.target.result != "undefined") {
                        // 그리드 CSV 데이터 적용시킴
                        AUIGrid.setCsvGridData(updResultGridID, event.target.result, false);
                        //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                        AUIGrid.removeRow(updResultGridID,0);
                    } else {
                        alert('No data to import!');
                    }
                };
                reader.onerror = function() {
                    alert('Unable to read ' + file.fileName);
                };
            }

            });

      //HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
        //서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
        //즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
        function commitFormSubmit() {

         AUIGrid.showAjaxLoader(updResultGridID);

         // Submit 을 AJax 로 보내고 받음.
         // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
         // 링크 : http://malsup.com/jquery/form/

         $('#updResultForm').ajaxSubmit({
             type : "json",
             success : function(responseText, statusText) {
                 if(responseText != "error") {

                     var csvText = responseText;

                     // 기본 개행은 \r\n 으로 구분합니다.
                     // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
                     // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
                     // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함.
                     csvText = csvText.replace(/\r?\n/g, "\r\n")

                     // 그리드 CSV 데이터 적용시킴
                     AUIGrid.setCsvGridData(updResultGridID, csvText);

                     AUIGrid.removeAjaxLoader(updResultGridID);

                   //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                     AUIGrid.removeRow(updResultGridID,0);
                 }
             },
             error : function(e) {
                 alert("ajaxSubmit Error : " + e);
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

   function fn_sendSms(){
	   var recipients = $("#recipient").val();
	   var msg = $("#msg").val();

	   if(isValidMobileNo(recipient) == false){
		   Common.alert("Invalid Phone Number");
	   }else{
		   Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:recipients , msg :msg} , function(result) {
		        console.log("sms.");
		        console.log( result);

		        if(result.isOky =="OK"){
		               Common.alert("SMS has successfully added into SMS queue list.<br />" ,function (){
		            	   $("#editWindow #recipient").val("");
		            	   $("#editWindow #msg").val("");
		            	   $("#editWindow").hide();
		               } );

		        }
		    });
	   }
   }

    $(function(){
   	    $("#search").click(function(){
   	    	/* if(fn_validSearchList()) */
   	    	    getBulkSmsListAjax();
         });

        $("#clear").click(function(){
        });

        $("#bulkSMSUpload").click(function(){
            $("#smsBatchReq_wrap").show();
        });
    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

            if(FormUtil.isEmpty($('#searchExpStartDt').val()) && !FormUtil.isEmpty($('#searchExpEndDt').val())) {
                isValid = false;
                msg += '* Please Select Expired Start Date<br/>';
            }
            if(!FormUtil.isEmpty($('#searchExpStartDt').val()) && FormUtil.isEmpty($('#searchExpEndDt').val())) {
                isValid = false;
                msg += '* Please Select Expired End Date<br/>';
            }

            if(FormUtil.isEmpty($('#searchCrtStartDt').val()) && !FormUtil.isEmpty($('#searchCrtEndDt').val())) {
                isValid = false;
                msg += '* Please Select Create Start Date<br/>';
            }
            if(!FormUtil.isEmpty($('#searchCrtStartDt').val()) && FormUtil.isEmpty($('#searchCrtEndDt').val())) {
                isValid = false;
                msg += '* Please Select Create End Date<br/>';
            }

        if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function getBulkSmsListAjax() {
        Common.ajax("GET", "/logistics/sms/selectBulkSmsList.do",  $('#SearchForm').serialize(), function(result) {
          AUIGrid.setGridData(myGridID, result.data);
        });
    }

    function  isValidMobileNo(inputContact){
        if(isNaN(inputContact) == true){
            return false;
        }

        if(inputContact.length != 10 && inputContact.length != 11){
            return false;
        }
        if( inputContact.substr(0 , 3) != '010' &&
            inputContact.substr(0 , 3) != '011' &&
            inputContact.substr(0 , 3) != '012' &&
            inputContact.substr(0 , 3) != '013' &&
            inputContact.substr(0 , 3) != '014' &&
            inputContact.substr(0 , 3) != '015' &&
            inputContact.substr(0 , 3) != '016' &&
            inputContact.substr(0 , 3) != '017' &&
            inputContact.substr(0 , 3) != '018' &&
            inputContact.substr(0 , 3) != '019'
          ){
            return false;
        }

        return true;

    }


  //그리드 초기화.
    function resetUpdatedItems() {
         AUIGrid.resetUpdatedItems(updResultGridID, "a");
     }

    function fn_resultFileUp(){
        //param data array
        var data = {};
        var gridList = AUIGrid.getGridData(updResultGridID);       //그리드 데이터

        //array에 담기
        if(gridList.length > 0) {
            data.all = gridList;
        }  else {
            alert('Select the CSV file on the local PC');
            return;
            //data.all = [];
        }

        //Ajax 호출
        Common.ajax("POST", "/logistics/sms/uploadSmsBatch.do", data, function(result) {
            resetUpdatedItems(); // 초기화

            var message = "";

	            if(result.code == "FAILED"){
	                for(var i = 0; i < result.data.length; i++){
	                	if(result.data[i].validPhNo == false)
	                    message += "Invalid Phone Number : " + result.data[i].msisdn + " at Line: " + result.data[i].line + "<br />";
	               }
	                Common.alert(message);
	            }else{
	                message += "Total SMS : " + result.data[0].totalSms + "<br />";
	                message += "<br />Are you sure want to confirm this result ?<br />";

		            Common.confirm(message,
		            function (){
		                var data = {};

		                Common.ajax("POST", "/logistics/sms/createBulkSmsBatch.do", data,
		                    function(result) {
		                    Common.alert("<b>SMS records successfully uploaded.</b>");
		                    },
		                    function(result) {
		                        Common.alert("<b>Failed to upload.<br />Please try again later.</b>");
		                        });
		                });
		            }
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : "
                            + jqXHR.responseJSON.detailMessage);
                    } catch (e) {
                        console.log(e);
                        }
                    alert("Fail : " + jqXHR.responseJSON.message);
                    });
    }
</script>
</head>
<body>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>SMS</li>
    <li>Bulk SMS</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Bulk SMS </h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="SearchForm" name="SearchForm"   method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td>
    <input type="text" id="searchRefNo" name="searchRefNo" title="" placeholder="Reference No" class="w100p" />
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchCrtStartDt" name="searchCrtStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="searchCrtEndDt" name="searchCrtEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Create User</th>
    <td>
    <input type="text" id="searchCreateUser" name="searchCreateUser" title="" placeholder="Create User" class="w100p" />
    </td>
    <th scope="row">Expired Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchExpStartDt" name="searchExpStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="searchExpEndDt" name="searchExpEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
   <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
            <li><p class="btn_grid"><a id="bulkSMSUpload">Bulk SMS Upload</a></p></li>
    <%-- </c:if> --%>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>

</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<!-------------------------------------------------------------------------------------
    POP-UP (BULK SMS VIEW)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>Bulk SMS Detail</h1>
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
                            <th scope="row">Reference No.</th>
                            <td id="view_refNo"></td>
                            <th scope="row">Total SMS</th>
                            <td id="view_totalSms"></td>
                        </tr>
                        <tr>
                            <th scope="row">Create User</th>
                            <td id="view_crtUsr"></td>
                            <th scope="row">Create  Date</th>
                            <td id="view_crtDt"></td>
                        </tr>
                        <tr>
                            <th scope="row">Expired Date</th>
                            <td colspan="3" id="view_exprDt"></td>
                        </tr>
                    </tbody>
                </table>
            </article>
            <!-- #########SMS Content######### -->
                <!-- table start -->
                    <!-- grid_wrap start -->
                    <aside class="title_line"><!-- title_line start -->
                    <header class="pop_header" id="pop_header">
                    <h1>View SMS Content</h1>
                     </header>
                    </aside><!-- title_line end -->
                    <table class="type1">
                        <caption>table</caption>
                        <tbody>
                            <tr>
                                <td colspan='5'>
                                    <div id="smsDetails_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                <!-- grid_wrap end -->
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<!-------------------------------------------------------------------------------------
    POP-UP (BULK SMS UPLOAD)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="smsBatchReq_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="smsBatchReq_wrap_pop_header">
        <h1>SMS Batch Request</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#smsBatchReq_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="updResultForm" id="updResultForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Batch File</th>
                        <td>
                            <!-- auto_file start -->
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
                           <!-- auto_file end -->
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>

        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="updResult_grid_wrap" style="display:none;"></article>
            <!-- grid_wrap end -->
        </section><!-- search_result end -->
        <!-- search_table end -->

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();">Upload</a></p></li>
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/service/SMS_Batch.csv">Download CSV Format</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

</section><!-- content end -->

