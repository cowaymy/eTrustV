<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;
var myGridID2;
var selectedGridValue; 
var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);

     // 그리드 생성
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	//myGridID2 = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,null,gridPros);
	
	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
});
 

// AUIGrid 칼럼 설정
var columnLayout = [ 
    {
        dataField : "enrlid",
        headerText : "Enroll ID",
        editable : false,
        width : 200
    }, {
        dataField : "name",
        headerText : "Issue Bank",
        style : "my-custom-up",
        editable : false
    }, {
        dataField : "createdate",
        headerText : "Create Date",
        editable : false
    }, {
        dataField : "c1",
        headerText : "Creator",
        editable : false,
        width : 250
    }];
    
//AUIGrid 칼럼 설정
var columnLayout2 = [ 
    {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 150
    }, {
        dataField : "accNo",
        headerText : "Account No",
        editable : false,
        width : 200
    }, {
        dataField : "accName",
        headerText : "Name",
        editable : false,
        style : "my-custom-up",
        width : 350
    }, {
        dataField : "accNric",
        headerText : "NRIC",
        editable : false,
        width : 200
    }];
    
// ajax list 조회.
    function searchList()
    {      selectedGridValue = undefined;//그리드 value값 초기화
    	   Common.ajax("GET","/payment/selectEnrollmentList.do",$("#searchForm").serialize(), function(result){
    		AUIGrid.setGridData(myGridID, result);
    	});
    }
    
    view_Enrollment = function() {
        var enrollId;
        var creator;
        var values = []; //ArrayList 값을 받을 변수를 선언
        if(selectedGridValue !=  undefined){
        	 $("#popup_wrap").show();
        	 
        	 myGridID2 = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,null,gridPros);
        	 enrollId=AUIGrid.getCellValue(myGridID, selectedGridValue, "enrlid");
        	 
        }else{
        	$("#popup_wrap").hide();
        	Common.alert("No enrollment record selected.");
            return;
        }

        Common.ajax("GET", "/payment/selectViewEnrollment.do",{"enrollId":enrollId}, function(result) {

        	$('#enrlId').text(result.enrollInfo.enrlId);
            $('#crtDt').text(result.enrollInfo.crtDt);
            $('#issueBank').text(result.enrollInfo.code+" - "+result.enrollInfo.name);
            $('#c1').text(result.enrollInfo.c1);
            $('#debtDtFrom').text(result.enrollInfo.debtDtFrom);
            $('#debtDtTo').text(result.enrollInfo.debtDtTo);
            
            values = result.resultList ;

        },function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");

        });
        
        Common.ajax("GET","/payment/selectViewEnrollmentList.do",{"enrollId":enrollId}, function(result){
            AUIGrid.setGridData(myGridID2, result);
        });
    }
    
    new_Enrollment = function() {
    	$("#popup_wrap").hide();
        $("#popup_wrap2").show();
        $("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
    }
    
  //Save Data
    function fn_saveEnroll() {
    	var data = {};
        var cmbIssueBank2 = $("#cmbIssueBank2 option:selected").val();
        var rdpCreateDateFr2 = $("#rdpCreateDateFr2").val();
        var rdpCreateDateTo2 = $("#rdpCreateDateTo2").val();
        
        if(cmbIssueBank2 !="7"){
        	if(rdpCreateDateFr2 == ""){
        		//rdpCreateDateFr2 = "01/01/1900";
        	}else if(rdpCreateDateTo2 == "") {
        		//rdpCreateDateTo2 = "01/01/1900";
        	}
        }
    	
    	if (validation()) {  
    	    Common.ajax("POST", "/payment/saveEnroll.do",  $('#searchForm').serializeJSON(), function(result) {
    		var msg = result.message;
    		var enrlId = result.data.enrlId;
    		Common.alert(msg+enrlId);
    		// 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            //searchList();
            }, function(jqXHR, textStatus, errorThrown) {
            	Common.alert("실패하였습니다.");
            });
        }
    }
        
    function validation() {
        var result = true;
        var message = "";
        
        if($("#cmbIssueBank2 option:selected").val() ==""){
        	Common.alert("* Please select the issue bank.");
        	return;
        }else if($("#rdpCreateDateFr2").val() ==""){
        	Common.alert("* Please insert the debit date.");
        	return;
        }else if($("#cmbIssueBank2 option:selected").val() =="7"){
        	
        	if($("#rdpCreateDateTo2").val() ==""){
        		Common.alert("* Please insert the debit date (To).");
                return;	
        	}
        }
        
        return result;
    }
    
    function fn_IssueBank() {
		var issueBankVal = $("#cmbIssueBank2 option:selected").val();
		var issueMsg = "";
		
		//초기화
		$("#issueBankMsg").text("");
        $("#rdpCreateDateFr2").val("");
        $("#rdpCreateDateTo2").val("");
        $("#rdpCreateDateFr2").attr("disabled",false).attr("readonly",false);
		$("#rdpCreateDateTo2").attr("disabled",false).attr("readonly",false);

		switch (issueBankVal) {
		case "2":
			//ALB
			issueMsg = "+1 Day Send Same Day";
			 $("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
			$("#issueBankMsg").text(issueMsg); 
			$("#issueBankMsg").css("color","red");
			break;
			
		case "3":
			//CIMB
            //txtRemark.Text = "Same Day";
			$("#issueBankMsg").text(issueMsg); 
			break;
		
		case "5":
			//HLBB
			$("#issueBankMsg").text(issueMsg); 
            break;
         
		case "21":
			//MBB
			issueMsg = "+2 Days";
			$("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
            $("#issueBankMsg").text(issueMsg);
            $("#issueBankMsg").css("color","red");
            break;
            
		case "6":
			//PBB
            //txtRemark.Text = "Same Day";
			$("#issueBankMsg").text(issueMsg); 
            break;
            
		case "7":
			//RHB
			issueMsg = "Current Date";
            $("#issueBankMsg").text(issueMsg);
            $("#issueBankMsg").css("color","red");
            $("#rdpCreateDateFr2").attr("disabled",false).attr("readonly",false);
            $("#rdpCreateDateTo2").attr("disabled",false).attr("readonly",false);
            break;
            
		case "9":
			//BSN
			$("#issueBankMsg").text(issueMsg); 
			 $("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
            break;
            

		default:
		   $("#issueBankMsg").text(issueMsg);
		   $("#rdpCreateDateFr2").attr("disabled",false).attr("readonly",false);
		   $("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
			break;
		}
	}
    
    function fn_close() {
    	$('#popup_wrap').hide();
    	AUIGrid.destroy(myGridID2); 
	}
    
    function fn_close2() {
        $('#popup_wrap2').hide();
        $("#cmbIssueBank2").val('');
        $("#issueBankMsg").text("");
        $("#rdpCreateDateFr2").val("");
        $("#rdpCreateDateTo2").val("");
        $("#rdpCreateDateFr2").attr("disabled",false).attr("readonly",false);
        $("#rdpCreateDateTo2").attr("disabled",false).attr("readonly",false);
    }
</script>

<!-- content start -->
<form name="searchForm" id="searchForm">
    <section id="content">
        <ul class="path">
            <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
            <li>Payment</li>
            <li>Auto Debit</li>
            <li>Enrollment</li>
        </ul>
        
        <!-- title_line start -->
        <aside class="title_line">
            <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
            <h2>Enrollment</h2>   
            <ul class="right_btns">
                <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span>Search</a></p></li>
            </ul>    
        </aside>
        <!-- title_line end -->

        <!-- search_table start -->
        <section class="search_table">

            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Enroll ID</th>
                        <td><input type="text" title="orgCode" id="enrollID" name="enrollID" placeholder="Enroll ID" /></td>
                        <th scope="row">Creator</th>
                        <td><input type="text" title="grpCode" id="creator" name="creator"  placeholder="Creator (Username)"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Create Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input id="rdpCreateDateFr" name="rdpCreateDateFr" type="text" title="rdpCreateDateFr" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                            <span>~</span>
                            <p><input id="rdpCreateDateTo" name="rdpCreateDateTo"  type="text" title="rdpCreateDateTo" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">Issue Bank</th>
                        <td>
                            <select id="cmbIssueBank" name="cmbIssueBank" class="w100p">
                                <option value="" selected="selected">Issue Bank</option>
                                <option value="2">Alliance Bank</option>
                                <!-- <option value="3">CIMB Bank</option>
                                <option value="5">Hong Leong Bank</option> -->
                                <option value="21">Maybank</option>
                                <!-- <option value="6">Public Bank</option> -->
                                <option value="7">RHB Bank</option>
                                <option value="9">BSN Bank</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </section>
        <!-- search_table end -->

        <!-- search_result start -->
        <section class="search_result">
            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">                            
                            <li><p class="link_btn"><a href="javascript:view_Enrollment()">View Enrollment</a></p></li>
                        </ul>
                        <ul class="btns">                            
                            <li><p class="link_btn type2"><a href="#" onclick="javascript:new_Enrollment()">New Enrollment</a></p></li>                            
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
            <!-- grid_wrap start -->
            <article id="grid_wrap" class="grid_wrap mt10"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->
    </section>

    <!-- content end -->
    <div id="popup_wrap" style="display:none;">
        <!-- popup_wrap start -->
        <header class="pop_header">
            <!-- pop_header start -->
            <h1>VIEW ENROLLMENT</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_close();">CLOSE</a></p></li>
            </ul>
        </header>
        <!-- pop_header end -->

        <!-- pop_body start -->
        <section class="pop_body">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Enroll ID</th>
                        <td id="enrlId"></td>
                        <th scope="row">Create Date</th>
                        <td id="crtDt"></td>
                    </tr>
                    <tr>
                        <th scope="row">Issue Bank</th>
                        <td id="issueBank"></td>
                        <th scope="row">Creator</th>
                        <td id="c1"></td>
                    </tr>
                    <tr>
                        <th scope="row">Debit Date (From)</th>
                        <td id="debtDtFrom"></td>
                        <th scope="row">Debit Date (To)</th>
                        <td id="debtDtTo"></td>
                    </tr>
                </tbody>
            </table>
            
            <!-- search_result start -->
            <section class="search_result">
                <article class="grid_wrap"  id="grid_wrap2" style="width  : 100%;"></article>
            </section>
            <!-- search_result end -->
        </section>
        <!-- pop_body end -->
    </div>
    <!-- popup_wrap end -->

    <!-- popup_wrap start -->
    <div id="popup_wrap2" class="popup_wrap" style="display:none;">
        <!-- pop_header start -->
        <header class="pop_header">
        <h1>NEW ENROLLMENT</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_close2();">CLOSE</a></p></li>
            </ul>
        </header>
        <!-- pop_header end -->

        <!-- pop_body start -->
        <section class="pop_body">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Issue Bank<span class="must">*</span></th>
                        <td colspan="3">
                            <select id="cmbIssueBank2" name="cmbIssueBank2" onchange="fn_IssueBank();">
                                <option value="" selected="selected">Issue Bank</option>
                                <option value="2">Alliance Bank</option>
                                <!-- <option value="3">CIMB Bank</option>
                                <option value="5">Hong Leong Bank</option> -->
                                <option value="21">Maybank</option>
                                <!-- <option value="6">Public Bank</option> -->
                                <option value="7">RHB Bank</option>
                                <option value="9">BSN Bank</option>
                            </select>    
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Debit Date<span class="must">*</span></th>
                        <td colspan="3">
                            <div class="date_set w105p"><!-- date_set start -->   
                            <p><input id="rdpCreateDateFr2" name="rdpCreateDateFr2" type="text" title="rdpCreateDateFr2" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                            <span>~</span>
                            <p><input id="rdpCreateDateTo2" name="rdpCreateDateTo2"  type="text" title="rdpCreateDateTo2" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
                            </div>   
                            <p><span id="issueBankMsg"></span><p>
                        </td>

                    </tr>
                </tbody>
            </table>

            <ul class="center_btns">
                <li><p class="btn_grid"><a href="javascript:fn_saveEnroll();">Enroll</a></p></li>
            </ul>
        </section>
        <!-- pop_body end -->
    </div>
    <!-- popup_wrap end -->
</form>