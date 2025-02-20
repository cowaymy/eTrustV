<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
//     function fn_doSaveFilterInfo_Add() {

//          var  serialSaveForm ={
//             "lastSerial": $("#lastSerial").val(),
//             "lastSerial" : $("#prevSerial").val(),
//             "srvFilterId" : '${srvFilterId}',
//          }


//           Common.ajax("POST", "/services/bs/doSaveFilterInfo.do", serialSaveForm, function(result) {
//                console.log("fn_doSaveFilterInfo_Add.");
//                console.log(result);

//                if(result.code == "00"){
//                     $("#popClose").click();
//                     fn_getInActivefilterInfo();
//                     fn_getActivefilterInfo();
//                      //Common.alert("<b>The filter successfully added.</b>",fn_close);
//                      Common.alert("<b><spring:message code='service.msg.filter.add'/></b>",fn_close);
//                }else if (result.code == "88"){
//                    //Common.alert("<b>Failed to add this filter. Please try again later.</b>");
//                    Common.alert("<b>Can't add existed filter</b>");
//                }else{
//                     //Common.alert("<b>Failed to add this filter. Please try again later.</b>");
//                     Common.alert("<b><spring:message code='service.msg.filter.fail'/></b>");
//                }
//            });
//     }


    function fn_doSaveEdit(){

    	var  serialSaveForm ={
            "lastSerial": $("#lastSerial").val(),
            "prevSerial" : $("#prevSerial").val(),
            "srvFilterId" : '${srvFilterId}',
         };

    	 Common.ajax("POST", "/services/bs/doSaveFilterSerial.do", serialSaveForm, function(result) {
//              console.log("fn_doSaveFilterInfo_Add.");
             console.log(result);

             if(result.code == "00"){
                  $("#popClose").click();
                  fn_getInActivefilterInfo();
                  fn_getActivefilterInfo();
                  Common.alert("Filter serial no. successfully updated.",fn_close);
//              }else if (result.code == "88"){
//                  Common.alert("<b>Can't add existed filter</b>");
             }else{
                  Common.alert("Filter serial no. fail to update.");
             }
         });
    }

    function fn_close() {
        $("#popClose").click();
    }
</script>


<div id="popup_serialEditwrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Filter Serial No.</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
	<form action="#" method="post"  id='editSerialForm'  name='editSerialForm' >
<%-- 	   <input type="hidden" name="srvFilterId"  id="srvFilterId" value="${srvFilterId}"/> --%>

	   <section class="tap_wrap"><!--tap_wrap start -->
			<article class="tap_area"><!-- tap_area start -->
				<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>

				<tbody>
					<tr>
					    <td colspan="2"><span class="must" id="txtResult"><!-- *Some required fields are empty. --></span></td>
					</tr>
					<tr>
					    <th scope="row">Last serial no.</th>
						<td>
						    <input id="lastSerial" name="lastSerial" value="${hSEditSerialInfo.srvFilterLastSerial}" placeholder="Last Serial No." class="w100p" />
						</td>
					</tr>
					<tr>
					    <th scope="row">Previous serial no.</th>
					    <td>
					        <input id="prevSerial" name="prevSerial" value="${hSEditSerialInfo.srvFilterPrevSerial}" placeholder="Previous Serial No." class="w100p" />
					    </td>
					</tr>
				</tbody>
				</table><!-- table end -->

				 <ul class="center_btns">
				    <li><p class="btn_blue2 big"><a href="#"  onclick="fn_doSaveEdit()"><spring:message code='service.btn.Save'/></a></p></li>
				 </ul>

			</article><!-- tap_area end -->
		</section><!-- tap_wrap end -->
	</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
