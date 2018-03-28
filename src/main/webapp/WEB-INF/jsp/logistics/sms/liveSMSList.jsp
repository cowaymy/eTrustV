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
    var myGridID;
    var comboStatusCode = [{"codeId": "44","codeName": "Pending"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

    // AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [
{dataField: "smsId",headerText :"<spring:message code='log.head.smsid'/>"              ,width:  "5%"     ,height:30 , visible:false},
{dataField: "smsMsisdn",headerText :"<spring:message code='log.head.msisdn'/>"              ,width:  "10%"     ,height:30 , visible:true},
{dataField: "smsMsg",headerText :"<spring:message code='log.head.msg'/>"               ,width:  "40%"    ,height:30 , visible:true},
{dataField: "smsRefNo",headerText :"<spring:message code='log.head.refno'/>"     ,width: "5%"    ,height:30 , visible:true},
{dataField: "smsStatusCode",headerText :"<spring:message code='log.head.status'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsExprDt",headerText :"<spring:message code='log.head.exprDt'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsRetry",headerText :"<spring:message code='log.head.retry'/>"     ,width: "5%"    ,height:30 , visible:true},
{dataField: "userName",headerText :"<spring:message code='log.head.creator'/>"     ,width: "10%"    ,height:30 , visible:true},
{dataField: "smsCrtDt",headerText :"<spring:message code='log.head.createdate'/>"     ,width: "10%"    ,height:30 , visible:true}
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
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };

    var subgridpros = {
            // 페이지 설정
            usePaging : true,
            pageRowCount : 10,
            editable : true,
            noDataMessage : "출력할 데이터가 없습니다.",
            enableSorting : true,
            softRemoveRowMode:false
            };


    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);

        doDefCombo(comboStatusCode, '' ,'cmbStatus', 'M', 'f_multiCombo');

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
        {

        });

        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

        /* 팝업 드래그 end */
        });

    $(function() {
        $('#msg').keyup(function (e){

            var content = $(this).val();

            $('#_charCounter').html('Total Character(s) : '+content.length);
        });
        $('#msg').keyup();
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
	   var recipients = $("#recipient").val().split(";");
	   var msg = $("#msg").val();
	   var i;
	   var valid = true;

	   console.log("result ::" +recipients);

	    for(i = 0; i < recipients.length; i ++){
	    	if(isValidMobileNo(recipients[i]) == false){
	            valid = false;
	            //Common.alert("Invalid Phone Number");
	        }
	    }

	    if(valid != false && msg != ""){
		    for(i = 0; i < recipients.length; i ++){
		        /* Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:recipients[i] , msg :msg} , function(result) {
		            console.log("sms.");
		            console.log( result);
		            }); */
		    }

		    Common.alert("SMS has successfully added into SMS queue list.<br />" ,function (){
                $("#editWindow #recipient").val("");
                $("#editWindow #msg").val("");
                $("#editWindow").hide();
                } );

        }else if(msg == null || msg == ""){
            Common.alert("Message cannot be empty");
        } else {
        	 Common.alert("Invalid Phone Number");
        }

   }

    $(function(){
   	    $("#search").click(function(){
   	    	if(fn_validSearchList())
   	    	    getLiveSmsListAjax();
         });

        $("#clear").click(function(){
        });

        $("#sendNewSms").click(function(){
            $("#editWindow").show();
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

    function getLiveSmsListAjax() {
        Common.ajax("GET", "/logistics/sms/selectLiveSmsList.do",  $('#SearchForm').serialize(), function(result) {
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

</script>
</head>
<body>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>SMS</li>
    <li>Live SMS</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Live SMS </h2>
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
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MSISDN</th>
    <td>
    <input type="text" id="searchMsisdn" name="searchMsisdn" title="" placeholder="MSISDN" class="w100p" />
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchCrtStartDt" name="searchCrtStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="searchCrtEndDt" name="searchCrtEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Reference No</th>
    <td>
    <input type="text" id="searchRefNo" name="searchRefNo" title="" placeholder="Reference No" class="w100p" />
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
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="cmbStatus" name="cmbStatus"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
   <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
            <li><p class="btn_grid"><a id="sendNewSms">Send New SMS</a></p></li>
    <%-- </c:if> --%>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>

</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<!-- insert into -->
<div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Send New SMS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="smsForm" name="smsForm" method="POST">
<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:700px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Recipient</th>
    <td ><input type="text" name="recipient" id="recipient" class="w100p"/>
    </td>
</tr>
<tr>
    <td colspan="2"><span></span>* Separate the mobile number with semicolon(;).</td>
</tr>
<tr>
    <th scope="row">Message</th>
    <td>
        <textarea cols="20" rows="5" id="msg" name="msg" placeholder=""></textarea>
    </td>
</tr>
<tr>
    <td colspan="2"><span id="_charCounter"><spring:message code="sal.title.text.totChars" /></span></td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_sendSms();">Send SMS</a></p></li>
<%-- </c:if> --%>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_nonvalueItem('2');">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>

</section><!-- content end -->

