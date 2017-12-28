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

     // 그리드 생성
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	
	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
});
 

// AUIGrid 칼럼 설정
var columnLayout = [ 
    {
        dataField : "enrlid",
        headerText : "<spring:message code='pay.head.enrollId'/>",
        editable : false,
        width : 200
    }, {
        dataField : "name",
        headerText : "<spring:message code='pay.head.issueBank'/>",
        style : "my-custom-up",
        editable : false
    }, {
        dataField : "createdate",
        headerText : "<spring:message code='pay.head.createDate'/>",
        editable : false
    }, {
        dataField : "c1",
        headerText : "<spring:message code='pay.head.creator'/>",
        editable : false,
        width : 250
    }];
    
//AUIGrid 칼럼 설정
var columnLayout2 = [ 
    {
        dataField : "salesOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false,
        width : 150
    }, {
        dataField : "accNo",
        headerText : "<spring:message code='pay.head.accountNo'/>",
        editable : false,
        width : 200
    }, {
        dataField : "accName",
        headerText : "<spring:message code='pay.head.name'/>",
        editable : false,
        style : "my-custom-up",
        width : 350
    }, {
        dataField : "accNric",
        headerText : "<spring:message code='pay.head.nric'/>",
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
        
        if(selectedGridValue !=  undefined){
        	 
        	 enrollId=AUIGrid.getCellValue(myGridID, selectedGridValue, "enrlid");
        	 
        	 Common.ajax("GET", "/payment/selectViewEnrollment.do",{"enrollId":enrollId}, function(result) {
        		 $("#popup_wrap").show();
                 $('#enrlId').text(result.enrollInfo.enrlId);
                 $('#crtDt').text(result.enrollInfo.crtDt);
                 $('#issueBank').text(result.enrollInfo.code+" - "+result.enrollInfo.name);
                 $('#c1').text(result.enrollInfo.c1);
                 $('#debtDtFrom').text(result.enrollInfo.debtDtFrom);
                 $('#debtDtTo').text(result.enrollInfo.debtDtTo);
                 
                 myGridID2 = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,null,gridPros);
                 AUIGrid.setGridData(myGridID2, result.resultList);

             },function(jqXHR, textStatus, errorThrown) {
                 Common.alert("<spring:message code='pay.alert.fail'/>");
             });
        	 
        }else{
        	$("#popup_wrap").hide();
        	Common.alert("<spring:message code='pay.alert.noEnrollment'/>");
            return;
        }
    }
    
    new_Enrollment = function() {
    	$("#popup_wrap").hide();
        $("#popup_wrap2").show();
        $("#rdpCreateDateTo2").attr("disabled",true).attr("readonly",false);
    }
    
    //Save Data
    function fn_saveEnroll() {
    	
    	if (validation()) {
    	    Common.ajax("GET", "/payment/saveEnroll.do",  $("#enrollForm").serialize() , function(result) {
	    		var msg = result.message;
	    		var enrlId = result.data.enrlId;
	    		Common.alert(msg+enrlId);
            }, function(jqXHR, textStatus, errorThrown) {
            	Common.alert("<spring:message code='pay.alert.fail'/>");
            });
    	    
        }
    }
        
    function validation() {
        var result = true;
        var message = "";
        
        if($("#cmbIssueBank2 option:selected").val() ==""){
        	
        	Common.alert("<spring:message code='pay.alert.selectClaimIssueBank'/>");
        	return;
        	
        }else if($("#rdpCreateDateFr2").val() ==""){
        	
        	Common.alert("<spring:message code='pay.alert.insertDate'/>");
        	return;
        	
        }else if($("#cmbIssueBank2 option:selected").val() =="7"){
        	
        	if($("#rdpCreateDateTo2").val() ==""){
        		Common.alert("<spring:message code='pay.alert.debitDateTo'/>");
                return;
                
        	}else{
        		
        		var startDate = $('#rdpCreateDateFr2').val();
                var startDateArr = startDate.split('/');
                var endDate = $('#rdpCreateDateTo2').val();
                var endDateArr = endDate.split('/');
                var startDateCompare = new Date(startDateArr[2], parseInt(startDateArr[1])-1, startDateArr[0]);
                var endDateCompare = new Date(endDateArr[2], parseInt(endDateArr[1])-1, endDateArr[0]);
        		
        		if($("#rdpCreateDateFr2").val() != ""){
        			if(startDateCompare.getTime() > endDateCompare.getTime()) {
        				 Common.alert("<spring:message code='pay.alert.debitDateFromTo'/>");
        				 return;
        			}
        		}
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
    
    function fn_clear(){
        $("#searchForm")[0].reset();
    }
</script>

<!-- content start -->
<section id="content">
        <ul class="path">
            <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        </ul>
        
        <!-- title_line start -->
        <aside class="title_line">
            <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
            <h2>Enrollment</h2>   
            <ul class="right_btns">
               <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
               </c:if>
                <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
            </ul>    
        </aside>
        <!-- title_line end -->

        <!-- search_table start -->
        <section class="search_table">
            <form name="searchForm" id="searchForm"  method="post">
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
                            <td><input type="text" title="orgCode" id="enrollID" name="enrollID" placeholder="Enroll ID" class="w100p"/></td>
                            <th scope="row">Creator</th>
                            <td><input type="text" title="grpCode" id="creator" name="creator"  placeholder="Creator (Username)" class="w100p"/></td>
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
            </form>
        </section>
        <!-- search_table end -->

        <!-- search_result start -->
        <section class="search_result">
            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                 <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                      
                            <li><p class="link_btn"><a href="javascript:view_Enrollment()"><spring:message code='pay.btn.link.viewEnrollment'/></a></p></li>
                       
                        </ul>
                        <ul class="btns"> 
                                                
                            <li><p class="link_btn type2"><a href="#" onclick="javascript:new_Enrollment()"><spring:message code='pay.btn.link.enrollment'/></a></p></li>                            
                      
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
               </c:if>
            </aside>
            <!-- link_btns_wrap end -->
            <!-- grid_wrap start -->
            <article id="grid_wrap" class="grid_wrap mt10"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->
    </section>

    <!-- content end -->
    <div id="popup_wrap" class="popup_wrap" style="display:none;">
        <!-- popup_wrap start -->
        <header class="pop_header">
            <!-- pop_header start -->
            <h1>VIEW ENROLLMENT</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_close();"><spring:message code='sys.btn.close'/></a></p></li>
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
        <form action="POST" id="enrollForm" name="enrollForm" >
        <!-- pop_header start -->
        <header class="pop_header">
        <h1>NEW ENROLLMENT</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_close2();"><spring:message code='sys.btn.close'/></a></p></li>
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
                <li><p class="btn_grid"><a href="javascript:fn_saveEnroll();"><spring:message code='pay.btn.enroll'/></a></p></li>
            </ul>
        </section>
        <!-- pop_body end -->
        </form>
    </div>
    <!-- popup_wrap end -->
