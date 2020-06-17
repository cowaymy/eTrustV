<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

    /* 커스텀 스타일 정의 */
    .auto_file2 {
        width:100%!important;
    }
    .auto_file2 > label {
        width:100%!important;
    }
   .auto_file2 label input[type=text]{width:40%!important; float:left}

</style>
<script type="text/javaScript">

//AUIGrid 생성 후 반환 ID
//var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
var popupObj;

$(document).ready(function(){

    // Moblie Popup Setting
    Common.setMobilePopup(true, false,'');

    $("#btnPopClose").click(function(){
    	fn_closeGrPop();
    });

    $("#btnPopConfirm").click(function(){
    	if($(this).parent().hasClass("btn_disabled") == true){
    		return false;
    	}

    	if(js.String.isEmpty($("#sDeliveryPopNo").val())){
    		return false;
    	}

    	var deliveryNo = $("#sDeliveryPopNo").val();

    	Common.ajax("GET", "/homecare/po/hcDeliveryGr/selectDeliveryConfirm.do", {"hmcDelvryNo":deliveryNo}, function(result) {
            Common.removeLoader();

            if(result != null && result.total > 0) {
                var item = result.dataList;
            	$("#itemCount").html(js.String.addcomma(js.String.naNcheck(item[0].itemCount)));
            	$("#ingGrNo").val(item[0].ingGrNo);      // 진행중인 GR번호
            	$("#grCdcId").val(item[0].cdc);          // 대상 CDC

            	$("#btnPopConfirm").parent().addClass("btn_disabled");

            	if(js.String.isEmpty(item[0].ingGrNo)){
            		$("#btnPopGr").parent().addClass("btn_disabled");
            		$("#btnPopSerialClear").parent().addClass("btn_disabled");
            		$("#btnPopSerial").parent().addClass("btn_disabled");
            	}

                $("#sDeliveryPopNo").prop("readonly", true).addClass("readonly");

                var isSerialCheck = false;
                var html = "";
                for(var i in item){
                	if(item[i].serialChk == "Y"){ isSerialCheck = true; }
                	var bfTotQty = js.String.naNcheck(item[i].delvryQty)
				                	- ( js.String.naNcheck(item[i].rciptGrQty)
				                		+ js.String.naNcheck(item[i].failGrQty));

                	console.log("item[i].delvryQty: " + item[i].delvryQty);

                	html += "<input type='hidden' name='hmcDelvryNo' value='"+item[i].hmcDelvryNo+"' />"
                	      + "<input type='hidden' name='hmcDelvryNoDtlNo' value='"+item[i].hmcDelvryNoDtlNo+"' />"
                	      + "<input type='hidden' name='poNo' value='"+item[i].poNo+"' />"
                	      + "<input type='hidden' name='poDtlNo' value='"+item[i].poDtlNo+"' />"
                	      + "<input type='hidden' name='stockId' value='"+item[i].stockId+"' />"
                	      + "<input type='hidden' name='stockCode' value='"+item[i].stockCode+"' />"
                	      + "<input type='hidden' name='stkTypeId' value='"+item[i].stkTypeId+"' />"
                	      + "<input type='hidden' name='bfTotQty' value='"+bfTotQty+"' />"
                	      + "<input type='hidden' name='delvryQty' value='"+item[i].delvryQty+"' />"
                		  + "<table class='type1'>"
                		  + "<caption>table</caption>"
                		  + "<colgroup>"
                		    + "<col style='width:40%' />"
                		    + "<col style='width:' />"
                		  + "</colgroup>"

                		  + "<tbody>"
                		    + "<tr>"
                		      + "<th scope='row' class='al_center' style='height:35px'>"
                		        + "Material / Delivery Qty"
                		      + "</th>"
                		      + "<td class='al_right'>"
                		        + item[i].stockName
                		        + " ( "+item[i].stockCode+" )"
                		        + " / "
                		        + js.String.addcomma(item[i].delvryQty)
                		      + "</td>"
                		    + "</tr>"
                		    /* + "<tr style='height:35px'>"
                		      + "<th scope='row' class='al_center'>"
                		        + "GR <br /> QC Pass / QC Fail"
                		      + "</th>"
                		      + "<td class='al_right'>"
                		        + js.String.addcomma(item[i].rciptGrQty)
                		        + " / "
                		        + js.String.addcomma(item[i].failGrQty)
                		      + "</td>"
                		    + "</tr>" */
                		    + "<tr style='height:35px'>"
                		      + "<th scope='row' class='al_center'>"
                		       // + "Before GR <br /> QC Pass / QC Fail"
                		       + "GR <br /> QC Pass / QC Fail"
                		      + "</th>"
                		      + "<td class='al_right'>"
                		        + "<span class='w100p'>"
                		        + "<input type='text' name='rciptTmQty' class='al_right "+fn_serialYnChk(item[i].serialChk)+"' style='min-width:10%; width:23%' maxlength='8' value='"+js.String.addcomma(item[i].rciptTmQty)+"' "+fn_serialYnChk(item[i].serialChk)+" onfocus='fnOnfocus(this);' '/>"
                		        + "&nbsp; &nbsp; / &nbsp; &nbsp;"
                		        + "<input type='text' name='failTmQty' class='al_right' style='min-width:10%; width:23%' maxlength='8' value='"+item[i].failTmQty+"' onkeydown='onlyNumber(this)' onfocus='fnOnfocus(this);''/>"
                		        + "</span>"
                		      + "</td>"
                		    + "</tr>"
                		  + "</tbody>"
                		  + "</table>";
                }

                $("#sTable").html(html);

                if(!isSerialCheck){
                	$("#btnPopSerial").parent().addClass("btn_disabled");
                	$("#btnPopSerialClear").parent().addClass("btn_disabled");
                }

                $('#deliveryArea').removeClass("blind");

            }else{
            	//Common.confirm();
            }

    	});

    });

    $("#btnPopClear").click(function(){
        $("#btnPopConfirm").parent().removeClass("btn_disabled");

        $("#sDeliveryPopNo").prop("readonly", false).removeClass("readonly");

        $("#btnPopGr").parent().removeClass("btn_disabled");
        $("#btnPopSerial").parent().removeClass("btn_disabled");
        $("#btnPopSerialClear").parent().removeClass("btn_disabled");
        $("#sTable").html("");
        $('#deliveryArea').addClass("blind");

        // Added to remove temporary scanned serial when "Clear" or "Close" button is clicked.
        /* if(js.String.isEmpty($("#ingGrNo").val())){
            // do nothing
        } else { // if ingGrNo is not null
        	Common
            .confirm(
                "Upon clearing, all scanned serial no. will be deleted.</br>Are you confirm to clear?",
                function(){
                    Common.ajax("POST", "/homecare/po/hcDeliveryGr/clearIngSerialNo.do"
                            , {"hmcGrNo":$("#ingGrNo").val()}
                            , function(result){
                                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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
        } */
    });

    $("#btnPopGr").click(function(){
    	if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

    	var param = $("#frmDeliveryGr").serializeObject();
    	var count = param.hmcDelvryNoDtlNo.length;

    	var item = [];
    	var validQty = 0, sumQty = 0;
        var failQty = 0;    // If there failQty, call confirm popup.

    	if(count == 1 ){

    		validQty = js.String.naNcheck(param.bfTotQty) - Number(js.String.deletecomma(param.rciptTmQty)) - js.String.naNcheck(param.failTmQty);
            if(validQty < 0){
                Common.alert("Total quantity cannot be exceeded.");
                return false;
            }

            sumQty += Number(js.String.deletecomma(param.rciptTmQty)) + js.String.naNcheck(param.failTmQty);
            failQty += js.String.naNcheck(param.failTmQty);

            console.log("param.stockCode: " + param.stockCode + " | sumQTY: " + sumQty + " | param.delvryQty: " + param.delvryQty);

            if (sumQty != param.delvryQty){
                Common.alert("<b><span style='color:red;'>FAILED!</span></b><br/>" +
                		"In-tally Quantity for Item Code (<b>" + param.stockCode + "</b>) <br/>Delivery Qty: <b>" + param.delvryQty + "</b><br/>QC Pass Qty: <b>" + param.rciptTmQty + "</b><br/>QC Fail Qty: <b>" + param.failTmQty + "</b>");
                return false;
            }

            item.push({"hmcGrNo":param.ingGrNo
                    , "cdc":param.grCdcId
                    , "hmcDelvryNo":param.hmcDelvryNo
                    , "hmcDelvryNoDtlNo":param.hmcDelvryNoDtlNo
                    , "poNo":param.poNo
                    , "poDtlNo":param.poDtlNo
                    , "stockId":param.stockId
                    , "stockCode":param.stockCode
                    , "stkTypeId":param.stkTypeId
                    , "qcQty":js.String.naNcheck(param.rciptTmQty)      //  serial scan : N일 경우
                    , "qcFailQty":js.String.naNcheck(param.failTmQty)
            });

    	}else{

    		for (var i=0; i<count; i++) {
                validQty = js.String.naNcheck(param.bfTotQty[i]) - Number(js.String.deletecomma(param.rciptTmQty[i])) - js.String.naNcheck(param.failTmQty[i]);
                if(validQty < 0){
                    Common.alert("Exceeded Total Quantity.");
                    return false;
                }

                sumQty += Number(js.String.deletecomma(param.rciptTmQty[i])) + js.String.naNcheck(param.failTmQty[i]);
                failQty += js.String.naNcheck(param.failTmQty[i]);
                console.log("param.stockCode[i]: " + param.stockCode[i] + " | sumQTY: " + sumQty + " | param.delvryQty: " + param.delvryQty[i]);

                if (sumQty != param.delvryQty[i]){
                	Common.alert("<b><span style='color:red;'>FAILED!</span></b><br/>" +
                			"In-tally Quantity for Item Code (<b>" + param.stockCode[i] + "</b>) <br/>Delivery Qty: <b>" + param.delvryQty[i] + "</b><br/>QC Pass Qty: <b>" + param.rciptTmQty[i] + "</b><br/>QC Fail Qty: <b>" + param.failTmQty[i] + "</b>");
                    return false;
                }

                item.push({"hmcGrNo":param.ingGrNo
                        , "cdc":param.grCdcId
                        , "hmcDelvryNo":param.hmcDelvryNo[i]
                        , "hmcDelvryNoDtlNo":param.hmcDelvryNoDtlNo[i]
                        , "poNo":param.poNo[i]
                        , "poDtlNo":param.poDtlNo[i]
                        , "stockId":param.stockId[i]
                        , "stockCode":param.stockCode[i]
                        , "stkTypeId":param.stkTypeId[i]
                        , "qcQty":js.String.naNcheck(param.rciptTmQty[i])      //  serial scan : N일 경우
                        , "qcFailQty":js.String.naNcheck(param.failTmQty[i])
                });
            }

    	}

	    if( sumQty == 0 ){
    		Common.alert("Please check the QTY.");
            return false;
    	}

        Common
	        .confirm(
	            "Do you want to GR?",
	            function(){
	            	if(failQty > 0){
	            		Common.confirm("QC Fail Qty will not be GR. Please Check again.", function(){
	            			fn_deliveryGr(item);
	            		});
	            	}else{
	            		fn_deliveryGr(item);
	            	}
	            }
        );


        // close the page
        if(Common.checkPlatformType() == "mobile") {
            if( typeof(opener.fn_PopClose) != "undefined" ){
                opener.fn_PopClose();
            }else{
                window.close();
            }
        } else {
            //$("#btnSearch").click();
            $('#_divDeliveryGrPop').remove();
        }

    });

    $("#btnPopSerial").click(function(){
        if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmDeliveryGr", "/logistics/serialMgmtNew/serialScanInPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/serialMgmtNew/serialScanInPop.do", null, null, true, '_serialScanPop');
        }
    });

    $("#btnPopSerialClear").click(function(){
    	if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

    	if(js.String.isEmpty($("#ingGrNo").val())){
    		// 진행중인 GR 없음.
    		return false;
    	}

        Common
            .confirm(
            	"Do you want to delete the serial in progress?",
                function(){
            		Common.ajax("POST", "/homecare/po/hcDeliveryGr/clearIngSerialNo.do"
            				, {"hmcGrNo":$("#ingGrNo").val()}
		            		, function(result){
		                        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
		                        $("#btnPopClear").click();
		                        $("#btnPopConfirm").click();
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


    $("#btnGrSearch").click(function(){
    	if($("#sDeliveryPopNo").hasClass("readonly") == true){
            return false;
        }
    	if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmSearchPop", "/homecare/po/hcDeliveryGrSearchPop/hcDeliveryGrSearchPop.do", {width:"800px", height:"720", resizable: "no", scrollbars: "yes"});
        } else{
        	Common.popupDiv("/homecare/po/hcDeliveryGrSearchPop/hcDeliveryGrSearchPop.do", null, null, true, '_divSearchPop');
        }
    });

    $("#sDeliveryPopNo").keydown(function() {
        if (event.keyCode === 13) {
    	    event.preventDefault();

    	    $("#btnPopConfirm").click();
    	};
   	});


});

function fn_deliveryGr(item){
    Common.ajax("POST", "/homecare/po/hcDeliveryGr/multiHcDeliveryGr.do"
            , {"grData":item}
            , function(result){
                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                $("#btnPopClear").click();
                $("#btnPopConfirm").click();
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

function fn_serialYnChk(ch){
	return ch == "Y"?"readonly":"";
}

function fn_closeGrPop(){

	console.log("1");
	// Added to remove temporary scanned serial when "Clear" or "Close" button is clicked.

	var ingGrNo = $("#ingGrNo").val();
	console.log("ingGrNo: " + ingGrNo);

    if(js.String.isEmpty($("#ingGrNo").val())){
    	// Moblie Popup Setting
        if(Common.checkPlatformType() == "mobile") {
            if( typeof(opener.fn_PopClose) != "undefined" ){
                opener.fn_PopClose();
            }else{
                window.close();
            }
        } else {
            //$("#btnSearch").click();
            $('#_divDeliveryGrPop').remove();
        }
    } else { // if ingGrNo is not null
    	console.log("2");
    	Common
	        .confirm(
	            "Upon closing, all temporary scanned serial no. will be removed (If Any).</br>Are you confirm to close?",
	            function(){
	            	Common.ajax("POST", "/homecare/po/hcDeliveryGr/clearIngSerialNo.do"
                            , {"hmcGrNo": ingGrNo}
                            , function(result){
	                            //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                            // Moblie Popup Setting
							    if(Common.checkPlatformType() == "mobile") {
							        if( typeof(opener.fn_PopClose) != "undefined" ){
							            opener.fn_PopClose();
							        }else{
							            window.close();
							        }
							    } else {
							        //$("#btnSearch").click();
							        $('#_divDeliveryGrPop').remove();
							    }
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
    }
}

function fn_PopSerialClose() {
    if(popupObj!=null){
		$("#btnPopConfirm").parent().removeClass("btn_disabled");
	    $("#btnPopConfirm").click();
    	popupObj.close();
    }
}


function fn_SearchPopClose(item){
	if(item != null){
	    $("#sDeliveryPopNo").val(item.hmcDelvryNo);
	    $("#btnPopConfirm").click();
	}
}

function onlyNumber(obj) {
    $(obj).keyup(function(){
         $(this).val($(this).val().replace(/[^0-9]/g,""));
    });
}

function fnOnfocus(obj){
	$(obj).select();
}

</script>

<div id="barScan_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HomeCare GR</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPopClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
	<aside class="title_line"><!-- title_line start -->
	<ul class="right_btns">
	    <li><p class="btn_blue"><a id="btnPopConfirm" href="#">Confirm</a></p></li>
	    <li><p class="btn_blue"><a id="btnPopClear" href="#">Clear</a></p></li>
	</ul>
	<br/>
	<b><span style="color:red;">*Remark:</span></b> <span style="color:red;">stock must be received in complete batch. Delivery quantity = GR quantity.</span>
	<br/>
	</aside><!-- title_line end -->
	<form id="frmGrSearch" name="frmGrSearch" action="#" method="post">
		<table class="type1">
			<caption>table</caption>
			<colgroup>
			    <col style="width:150px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
				    <th scope="row">Delivery No</th>
				    <td colspan="3" >
				        <p class="w100p">
				            <input type="text" id="sDeliveryPopNo" name="sDeliveryPopNo" placeholder="" style="width:86%; min-width:150px;"  value="" onfocus="fnOnfocus(this);"'/>
                            <a id="btnGrSearch"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search"/></a>
                        </p>

				    </td>
				</tr>
			</tbody>
		</table>
	</form>
	<form id="frmSearchPop" name="frmSearchPop" action="#" method="post"></form>

<!------------------------------------------------------------------------------
    Content START
------------------------------------------------------------------------------->
    <section id="deliveryArea" class="blind">

	    <section class="search_table"><!-- search_table start -->

		    <form id="frmDeliveryGr" name="frmDeliveryGr" action="#" method="post">
		    <input id="ingGrNo" name="ingGrNo"   type="hidden"/>
            <input id="grCdcId" name="grCdcId"   type="hidden"/>

			<aside class="title_line">
			  <h3>Delivery List</h3>

			  <ul class="right_btns">
		        <li><p class="btn_grid"><a id="btnPopGr">GR Complete</a></p></li>
		        <li><p class="btn_grid"><a id="btnPopSerialClear">Clear Serial</a></p></li>
		        <li><p class="btn_grid"><a id="btnPopSerial">Read Serial</a></p></li>
		      </ul>
			</aside>

		    <table class="type1">
		        <caption>table</caption>
		        <colgroup>
		            <col style="width:40%" />
		            <col style="width:*" />
		        </colgroup>
		        <tbody>
		            <tr>
		                <th scope="row">Item Count</th>
		                <td>
		                    <!-- <input id="itemCount" name="itemCount" type="text" placeholder="" class="w100p readonly" /> -->
		                    <span id="itemCount" name="itemCount" class="w100p al_right" />
		                </td>
		            </tr>
		        </tbody>
		    </table>

		    <aside class="title_line"><!-- title_line start -->
		        <h3></h3>
		    </aside><!-- title_line end -->

	        <div id="sTable"></div>
            </form>
	    </section><!-- tap_wrap end -->

    </section>
<!------------------------------------------------------------------------------
     Content END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
