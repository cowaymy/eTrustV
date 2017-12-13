<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">



$(document).ready(function(){
	
	
	
	
});

function fn_saveRemarkResult(){

	  var jsonObj = { 
			 "remark" : $("#remark").val(),
			  "counselingNo" :  $("#counselingNo").text(),
			  "mainDept" : $("#mainDept").text(),
			  "subDept" : $("#subDept").text(),
			  "regDate" : $("#regDate").text(),
			  "orderId" : $("#ordId").val(),
			  "hcId" : $("#hcId").val()
			 
	       };
	 var regDate =  $("#orderId").val();
	  console.log(regDate);
	  
	
	 Common.ajax("POST", "/services/tagMgmt/addRemarkResult.do", jsonObj , function(result) {
		  
		  
		  Common.alert(result.message);
		  
	  }); 
	

}









</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->


<header class="pop_header"><!-- pop_header start -->
<h1>tag Log List </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->
<input type="hidden" id="hcId"   value= "${tagMgmtDetail.hcId}">
<input  type="hidden" id="ordId"  value= "${tagMgmtDetail.ordId}">
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Tag Info</a></li>
    <li><a href="#">Respond Info</a></li>
</ul>

<!-- Tag Info Start -->
<article class="tap_area"><!-- tap_area start -->
    <section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1">
        <li><a href="#" class="on">Tag Basic Info</a></li>
        <li><a href="#">Caller Info</a></li>
    </ul>
    <!-- Tag Basic Info Start -->
    <article class="tap_area"><!-- tap_area start -->
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:160px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Inquiry Contact Number</th>
            <td><span id="counselingNo"><c:out value="${tagMgmtDetail.counselingNo}"/></span></td>
            <th scope="row">Inquiry Customer Name</th>
            <td><span><c:out value="${tagMgmtDetail.customerName}"/></span></td>
            <th scope="row">Inquiry Member Type</th>
            <td><span><c:out value="${tagMgmtDetail.classifyMem }"/></span></td>
        </tr>
        <tr>
            <th scope="row">In-charge Main Dept.</th>
            <td><span id ="mainDept"><c:out value="${tagMgmtDetail.mainDept }"/></span></td>
            <th scope="row">In-charge Sub Dept.</th>
            <td><span id="subDept"><c:out value="${tagMgmtDetail.subDept }"/></span></td>
            <th scope="row">Main Inquiry</th>
            <td><span ><c:out value="${tagMgmtDetail.mainInquiry }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Customer Code</th>
            <td><span><c:out value="${tagMgmtDetail.customerNo }"/></span></td>
            <th scope="row">Order Number</th>
            <td><span><c:out value="${tagMgmtDetail.ordNo }"/></span></td>
            <th scope="row">Sub Main Inquiry</th>
            <td><span><c:out value="${tagMgmtDetail.subInquiry }"/></span></td>
        </tr>
        <tr>
            <th scope="row">Progress Status</th>
            <td><span><c:out value="${tagMgmtDetail.status }"/></span></td>
            <th scope="row">Complete Key-in Date</th>
            <td><span id="regDate"><c:out value="${tagMgmtDetail.regDate }"/></span></td>
            <th scope="row">Feedback Code</th>
            <td><span><c:out value="${tagMgmtDetail.feedbackCode }"/></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        <section class="tap_wrap"><!-- tap_wrap start -->
            <ul class="tap_type1">
                <li><a href="#" class="on">Order Info</a></li>
                <li><a href="#">HP/Cody Info</a></li>
            </ul>
            <!-- Order Info Start -->
            <article class="tap_area"><!-- tap_area start -->
                <table class="type1"><!-- table start -->
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
                    <th scope="row">Order No</th>
                    <td><span><c:out value="${tagMgmtDetail.ordNo }"/></span></td>
                    <th scope="row">App Type</th>
                    <td>Text</td>
                    <th scope="row">Product</th>    
                    <td>Text</td>
                </tr>
                <tr>
                    <th scope="row">Customer Name</th>
                    <td>Text</td>
                    <th scope="row">NRC Company No</th>
                    <td colspan="3">Text</td>
                </tr>
                </tbody>
                </table><!-- table end -->
            </article><!-- tap_area end -->
            <!-- Order Info End -->

            <!-- HP/Cody Info Start -->
            <article class="tap_area"><!-- tap_area start -->
                <article class="grid_wrap"><!-- grid_wrap start -->
                    <div class="divine_auto"><!-- divine_auto start -->
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                            <h3 class="pt0">Salesman Info</h3>
                            </aside><!-- title_line end -->

                            <table class="type1"><!-- table start -->
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:180px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row" rowspan="3">Order Made By</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Salesman Code</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Salesman Name</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Salesman NRIC</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Mobile No</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Office No</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">House No</th>
                                <td>Text</td>
                            </tr>
                            </tbody>
                            </table><!-- table end -->
                        </div>
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                            <h3 class="pt0">Cody Info</h3>
                            </aside><!-- title_line end -->

                            <table class="type1"><!-- table start -->
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:180px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row" rowspan="3">Service By</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Cody Code</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Cody Name</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Cody NRIC</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Mobile No</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">Office No</th>
                                <td>Text</td>
                            </tr>
                            <tr>
                                <th scope="row">House No</th>
                                <td>Text</td>
                            </tr>
                            </tbody>
                            </table><!-- table end -->
                        </div>
                    </div><!-- divine_auto end -->
                </article><!-- grid_wrap end -->
            </article><!-- tap_area end -->
            <!-- HP/Cody Info End -->

        </section><!-- tap_wrap end -->
    </article><!-- tap_area end -->
    <!-- Tag Basic Info End -->

    <!-- Caller Info Start -->
    <article class="tap_area"><!-- tap_area start -->
        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Name</th>
            <td>Text</td>
            <th scope="row">NRIC</th>
            <td>Text</td>
            <th scope="row">Company Name</th>
            <td>Text</td>
        </tr>
        <tr>
            <th scope="row">Contact(1)</th>
            <td>Text</td>
            <th scope="row">Contact(2)</th>
            <td>Text</td>
            <th scope="row">Email</th>
            <td>Text</td>
        </tr>
        </tbody>
        </table><!-- table end -->
    </article><!-- tap_area end -->
    <!-- Caller Info End -->

    </section><!-- tap_wrap end -->
</article><!-- tap_area end -->
<!-- Tag Info End -->

<!-- Respond Info Start -->
<article class="tap_area"><!-- tap_area start -->
    <aside class="title_line"><!-- title_line start -->
    <h3>Respond Info</h3>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

  
</article><!-- tap_area end -->
<!-- Respond Info End -->

</section><!-- tap_wrap end -->

<section class="search_table"><!-- search_table start -->

</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->



<article class="grid_wrap"><!-- grid_wrap start -->
  <aside class="title_line"><!-- title_line start -->
    <h3>Add Respond</h3>
    </aside><!-- title_line end -->
 
    <table class="type1"><!-- table start -->
  
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
   
    <tbody>
     
    <tr>
        <th scope="row">Status</th>
        <td>
            <select  id="status" name="status">
                <option value="1">Open</option>
                <option value="2">Pending</option>
                <option value="3">Solve</option>
                <option value="4">Not yet to solve</option>
                <option value="5">Close</option>
                <option value="6">Cancel</option>
            </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td><textarea name="remark" id="remark" cols="20" rows="5" placeholder=""></textarea></td>
         
    </tr>
    
    </tbody>
    
    </table><!-- table end -->

    <ul class="right_btns">
    <li><p class="btn_grid"><a  id="remark" onclick="fn_saveRemarkResult()">Save</a></p></li>
</ul>
    
    
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

</div>