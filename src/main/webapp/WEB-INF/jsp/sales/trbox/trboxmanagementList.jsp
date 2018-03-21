<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGrid;
    var viewGrid;
    var keepGrid;
    var statusList = [{"codeId": "1","codeName": "Active"},{"codeId": "36","codeName": "Closed"}];
 // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"rnum"      ,headerText:'<spring:message code="sal.title.text.rownum" />'     ,width:50    ,height:30 , visible:false},
                        {dataField:"boxid"     ,headerText:'<spring:message code="sal.title.text.boxId" />'     ,width:100   ,height:30 , visible:false},
                        {dataField:"boxno"     ,headerText:'<spring:message code="sal.title.text.boxNo" />'     ,width:"14%" ,height:30 , visible:true},
                        {dataField:"status"    ,headerText:'<spring:message code="sal.title.status" />'     ,width:"14%" ,height:30 , visible:true},
                        {dataField:"statusid"  ,headerText:'<spring:message code="sal.title.text.statusID" />'  ,width:100   ,height:30 , visible:false},
						{dataField:"statuscd"  ,headerText:'<spring:message code="sal.title.text.stusCD" />'  ,width:100   ,height:30 , visible:false},
                        {dataField:"holder"    ,headerText:'<spring:message code="sal.title.text.location" />'   ,width:"15%" ,height:30 , visible:true},
                        {dataField:"branchid"  ,headerText:'<spring:message code="sal.title.text.branchId" />'   ,width:120   ,height:30 , visible:false},
                        {dataField:"branchcd"  ,headerText:'<spring:message code="sal.title.text.branchCode" />' ,width:120   ,height:30 , visible:false},
						{dataField:"branchnm"  ,headerText:'<spring:message code="sal.title.text.branchName" />' ,width:120   ,height:30 , visible:false},
                        {dataField:"bookqty"   ,headerText:'<spring:message code="sal.title.text.qtyBook" />'   ,width:"14%" ,height:30 , visible:true },
                        {dataField:"scrapdt"   ,headerText:'<spring:message code="sal.title.text.scrapDate" />' ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:true },
                        {dataField:"scrapdt2"  ,headerText:'<spring:message code="sal.title.text.scrapDate" />' ,width:"14%" ,height:30 , visible:false },
                        {dataField:"crtdt"     ,headerText:'<spring:message code="sal.text.createAt" />'  ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:true },
                        {dataField:"crtdt2"    ,headerText:'<spring:message code="sal.text.createAt" />'  ,width:"14%" ,height:30 , visible:false },
						{dataField:"opendt"    ,headerText:'<spring:message code="sal.title.text.openDt" />'    ,width:"14%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:false },
						{dataField:"opendt2"   ,headerText:'<spring:message code="sal.title.text.openDt" />'    ,width:"14%" ,height:30 , visible:false },
                        {dataField:"crtname"   ,headerText:'<spring:message code="sal.text.createBy" />'  ,width:"15%" ,height:30 , visible:true },
                        {dataField:"crtuser"   ,headerText:'<spring:message code="sal.title.text.createId" />'  ,width:120   ,height:30 , visible:false}
                       ];

    var subculomnlayout = [
                        {dataField:"trbid"     ,headerText:'<spring:message code="sal.title.text.bookId" />'     ,width:100   ,height:30 , visible:false},
                        {dataField:"trbno"     ,headerText:'<spring:message code="sal.title.bookNo" />'     ,width:"20%" ,height:30 , visible:true},
                        {dataField:"reciptstr" ,headerText:'<spring:message code="sal.title.from" />'        ,width:"20%" ,height:30 , visible:true},
                        {dataField:"reciptend" ,headerText:'<spring:message code="sal.title.to" />'          ,width:"20%" ,height:30 , visible:true},
                        {dataField:"crtnm"     ,headerText:'<spring:message code="sal.title.text.keepBy" />'     ,width:"20%" ,height:30 , visible:true},
                        {dataField:"crtdt"     ,headerText:'<spring:message code="sal.title.text.keepDate" />'   ,width:"20%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:true}
                       ];

    var keepculomnlayout = [
                           {dataField:"trbdetid"  ,headerText:'<spring:message code="sal.title.text.detId" />'      ,width:100   ,height:30 , visible:false},
                           {dataField:"trbid"     ,headerText:'<spring:message code="sal.title.text.bookId" />'     ,width:100   ,height:30 , visible:false},
                           {dataField:"trbno"     ,headerText:'<spring:message code="sal.title.bookNo" />'     ,width:"18%" ,height:30 , visible:true},
                           {dataField:"reciptstr" ,headerText:'<spring:message code="sal.title.from" />'        ,width:"18%" ,height:30 , visible:true},
                           {dataField:"reciptend" ,headerText:'<spring:message code="sal.title.to" />'          ,width:"18%" ,height:30 , visible:true},
                           {dataField:"crtnm"     ,headerText:'<spring:message code="sal.title.text.keepBy" />'     ,width:"18%" ,height:30 , visible:true},
                           {dataField:"crtdt"     ,headerText:'<spring:message code="sal.title.text.keepDate" />'   ,width:"18%" ,height:30 , dataType : "date", formatString : "dd/mm/yyyy" ,visible:true},
                           {
                               dataField : "undefined",
                               headerText : " ",
                               renderer : {
                                   type : "ButtonRenderer",
                                   labelText : "Remove",
                                   onclick : function(rowIndex, columnIndex, value, item) {
                                       getKeepRemoveAjax(rowIndex , item);
                                   }
                               }
                           }
                          ];

    var gridoptions = {showStateColumn : true , editable : false, pageRowCount : 20, usePaging : true, useGroupingPanel : false };

    $(document).ready(function(){
    	listGrid = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        viewGrid = GridCommon.createAUIGrid("view_grid_wrap", subculomnlayout,"", gridoptions);
        keepGrid = GridCommon.createAUIGrid("keep_grid_wrap", keepculomnlayout,"", gridoptions);
        $("#popup_wrap").hide();
        $("#keep_popup_wrap").hide();
    	doGetComboSepa('/common/selectBranchCodeList.do', '9' , ' - ' , '','branchid', 'S' , '');
    	//doGetComboSepa('/misc/TRBox/selectTransferCodeList.do', 'branch' , ' - ' , '','branchid', 'S' , '');
        doDefCombo(statusList, '1' ,'status', 'M', 'f_multiCombo');

        AUIGrid.bind(listGrid, "cellClick", function( event )
        {

        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
            getViewListAjax(event.item , 'v');
            $("#vboxno").text(itm.boxno);
            $("#vcrtdt").text(itm.crtdt2);
            $("#vcrtuser").text(itm.crtname);
            $("#vstatus").text(itm.status);
            $("#vholder").text(itm.holder);
            $("#vopendt").text(itm.opendt2);
            $("#vexpirydt").text(itm.scrapdt2);
            $("#vtotalbook").text(itm.bookqty);
            $("#popup_wrap").show();

        });

    });

    function f_multiCombo(){
        $(function() {
            $('#status').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
        });
    }

    function getSearchListAjax(){
    	var url = "/misc/TRBox/getSearchTrboxManagementList.do";
        var param = $('#searchForm').serialize();
        Common.ajax("GET" , url , param , function(data){
            AUIGrid.setGridData(listGrid, data.data);

        });
    }

    function getViewListAjax(itm , str){
    	var url = "/misc/TRBox/getSelectTrboxManageDetailList.do";
        var param = "trboxid="+itm.boxid;
        Common.ajax("GET" , url , param , function(data){
        	if (str == 'v'){
        		AUIGrid.setGridData(viewGrid, data.data);
        	}else if (str == 'k'){
        		AUIGrid.setGridData(keepGrid, data.data);
        	}

            if (str == 'v'){
            	AUIGrid.resize(viewGrid);
            }else if (str == 'k'){
            	AUIGrid.resize(keepGrid);
            }
        });
    }

    function getKeepRemoveAjax(row , itm){
        var url = "/misc/TRBox/getUpdateKeepReleaseRemove.do";
        console.log(itm);
        var param = "trbdetid="+itm.trbdetid;
        Common.ajax("GET" , url , param , function(data){
            //Common.alert("[" + itm.trbno + "] successfully removed from box.");
            Common.alert('<spring:message code="sal.alert.msg.successfullyRemoved" arguments="'+itm.trbno+'"/>');
            AUIGrid.removeRow(keepGrid, "selectedIndex");
            AUIGrid.removeSoftRows(keepGrid);
        });
    }

    // Report Download
    function fn_downloadReport(method){
    	//Validation
    	//Non Click Check
    	var gridObj = AUIGrid.getSelectedItems(listGrid);
    	if(gridObj == null || gridObj.length <= 0 ){
            Common.alert("* No Data Selected. ");
            return;
        }

    	var boxId = gridObj[0].item.boxid;
    	var boxno = gridObj[0].item.boxno;

    	//VIEW
        if(method == "PDF"){
            $("#viewType").val("PDF");//method
        }
        if(method == "EXCEL"){
            $("#viewType").val("EXCEL");//method
        }

        //CURRENT DATE
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        //Report Params
        //Essen
        $("#reportFileName").val("/sales/BoxTRBookListing_Excel.rpt"); //File Name
        $("#reportDownFileName").val(boxno+"_"+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME
        //params
        $("#BoxID").val(boxId);
        var option = {
                isProcedure : false // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("dataForm", option);

    }

    $(function(){
	    $("#btnSrch").click(function(){
	        getSearchListAjax();
	    });
	    $("#viewclose").click(function(){
	    	$("#popup_wrap").hide();
	    	$("#vboxno").text('');
            $("#vcrtdt").text('');
            $("#vcrtuser").text('');
            $("#vstatus").text('');
            $("#vholder").text('');
            $("#vopendt").text('');
            $("#vexpirydt").text('');
            $("#vtotalbook").text('');
            AUIGrid.setGridData(viewGrid, []);
        });
	    $("#insClose").click(function(){
	    	$("#edit_popup_wrap").hide();
	    });
	    $("#insNew").click(function(){
	    	$("#insBrnch").text('${SESSION_INFO.code} - ${SESSION_INFO.branchName}');
	    	$("#loginbranchid").val('${SESSION_INFO.userBranchId}');
	    	$("#loginbranchcd").val('${SESSION_INFO.code}');
            $("#edit_popup_wrap").show();
        });
	    $("#insSave").click(function(){
	    	var url = "/misc/TRBox/postNewTrboxManagementSave.do";
	        var param = $('#insForm').serializeJSON();
	        console.log(param);
 	        Common.ajax("POST" , url , param , function(data){
				console.log(data);
 	            if (data.trboxno == "")
 	            {
 					Common.alert('Failed to save. Please try again later.');
 	            }else{
 					Common.alert('New box saved.<br /> Box Number :' + data.trboxno);
 					$("#btnSrch").click();
 					$("#insClose").click();
 				}

 	        });
        });
	    $("#btnKeep").click(function(){
	    	var selectedItems = AUIGrid.getSelectedItems(listGrid);
	    	if (selectedItems.length == 0 ){
	    		Common.alert("Selected Data");
	    		return false;
	    	}else{
		    	$("#keep_popup_wrap").show();
		    	var itm = selectedItems[0].item;
		    	getViewListAjax(itm , 'k');
		    	$("#kboxno").text(itm.boxno);
	            $("#kcrtdt").text(itm.crtdt2);
	            $("#kcrtuser").text(itm.crtname);
	            $("#kstatus").text(itm.status);
	            $("#kholder").text(itm.holder);
	            $("#kopendt").text(itm.opendt2);
	            $("#kexpirydt").text(itm.scrapdt2);
	            $("#ktotalbook").text(itm.bookqty);
		    	$("#ksboxid").val(itm.boxid);
	    	}
        });
	    $("#keepBtnsrch").click(function(){
	    	var url = "/misc/TRBox/getSelectTrboxManageDetailList.do";
	    	//
	        var param = "trboxid="+$("#ksboxid").val()+"&bookno="+$("#ksbooxno").val()+"&receiptfr="+$("#ksreceiptfr").val()+"&receiptto="+$("#ksreceiptto").val();
	        //$("#filterForm").serialize();
	    	Common.ajax("GET" , url , param , function(data){
	            AUIGrid.setGridData(keepGrid, data.data);
	            AUIGrid.resize(keepGrid);
	        });
        });
	    $("#filterBtn").click(function(){
            $("#filter_popup_wrap").show();
        });
	    $("#showallBtn").click(function(){
	    	var url = "/misc/TRBox/getSelectTrboxManageDetailList.do";
            //
            var param = "trboxid="+$("#ksboxid").val();
            //$("#filterForm").serialize();
            Common.ajax("GET" , url , param , function(data){
                AUIGrid.setGridData(keepGrid, data.data);
                AUIGrid.resize(keepGrid);
            });
        });
	    $("#btnClose").click(function(){
	    	var selectedItems = AUIGrid.getSelectedItems(listGrid);
	    	if (selectedItems.length == 0 ){
                Common.alert("Selected Data");
                return false;
            }else{
            	var itm = selectedItems[0].item;
            	console.log(itm);
            	$("#close_popup_wrap").show();
                $("#cboxno").text(itm.boxno);
                $("#ccrtdt").text(itm.crtdt2);
                $("#ccrtuser").text(itm.crtname);
                $("#cstatus").text(itm.status);
                $("#cholder").text(itm.holder);
                $("#copendt").text(itm.opendt2);
                $("#cexpirydt").text(itm.scrapdt2);
                $("#ctotalbook").text(itm.bookqty);
                $("#csboxid").val(itm.boxid);

                if (itm.statusid == '1'){
                	$("#closeBtn").text("Close Box");
                }else if (itm.statusid == '36'){
                	$("#closeBtn").text("Reopen Box");
                }
            }

	    });
	    $("#closeBtn").click(function(){
            var selectedItems = AUIGrid.getSelectedItems(listGrid);
            var itm = selectedItems[0].item;
            var url = "/misc/TRBox/getCloseReopn.do";

            var param = "trboxid="+itm.boxid;

            if ($("#closeBtn").text() == "Close Box"){
                param += "&statusid=36";
            }else if ($("#closeBtn").text() == "Reopen Box"){
            	param += "&statusid=1";
            }

            //$("#filterForm").serialize();
            Common.ajax("GET" , url , param , function(data){
                if ($("#closeBtn").text() == "Close Box"){
                	Common.alert('<spring:message code="sal.alert.msg.boxSuccessfullyClose" />');
                	$("#closeBtn").text("Reopen Box");
                }else if ($("#closeBtn").text() == "Reopen Box"){
                	Common.alert('<spring:message code="sal.alert.msg.boxSuccessfullyReopen" />');
                    $("#closeBtn").text("Close Box");
                }
            });
        });
	    $("#closePopupCloBtn").click(function(){
	    	getSearchListAjax();
        });
	    $("#transferCloseBtn").click(function(){
            getSearchListAjax();
        });
	    $("#updateCloseBtn").click(function(){
            getSearchListAjax();
        });
	    $("#updBtn").click(function(){
	    	var selectedItems = AUIGrid.getSelectedItems(listGrid);
	    	console.log(selectedItems.length);
            if (selectedItems.length == 0 ){
                Common.alert("Selected Data");
                return false;
            }else{
                var itm = selectedItems[0].item;
                $("#update_popup_wrap").show();
                $("#uboxno").text(itm.boxno);
                $("#ucrtdt").text(itm.crtdt2);
                $("#ucrtuser").text(itm.crtname);
                $("#ustatus").text(itm.status);
                $("#uholder").text(itm.holder);
                $("#uopendt").text(itm.opendt2);
                $("#uexpirydt").text(itm.scrapdt2);
                $("#utotalbook").text(itm.bookqty);
                $("#usboxid").val(itm.boxid);

                $("#uscrapdt").val(itm.scrapdt2);
            }
        });
	    $("#updSaveBtn").click(function(){
	    	var selectedItems = AUIGrid.getSelectedItems(listGrid);
            var itm = selectedItems[0].item;
            var url = "/misc/TRBox/getUpdateTrBoxInfo.do";

            var param = "trboxid="+itm.boxid + "&scrapdt="+$("#uscrapdt").val();

	    	Common.ajax("GET" , url , param , function(data){
                var itm = data.data[0];
                $("#uboxno").text(itm.boxno);
                $("#ucrtdt").text(itm.crtdt2);
                $("#ucrtuser").text(itm.crtname);
                $("#ustatus").text(itm.status);
                $("#uholder").text(itm.holder);
                $("#uopendt").text(itm.opendt2);
                $("#uexpirydt").text(itm.scrapdt2);
                $("#utotalbook").text(itm.bookqty);
                $("#usboxid").val(itm.boxid);

                $("#uscrapdt").val(itm.scrapdt2);
            });
	    });
	    $("#singletranBtn").click(function(){
	    	var selectedItems = AUIGrid.getSelectedItems(listGrid);
	    	if (selectedItems.length == 0 ){
                Common.alert("Selected Data");
                return false;
            }else{
		    	var itm = selectedItems[0].item;

		    	doGetComboSepa('/misc/TRBox/selectTransferCodeList.do', 'branch' , ' - ' , '','tbrnch', 'S' , '');
                doGetComboSepa('/misc/TRBox/selectTransferCodeList.do', 'courier' , ' - ' , '','tcourier', 'S' , '');

	            $("#tboxno").text(itm.boxno);
	            $("#tcrtdt").text(itm.crtdt2);
	            $("#tcrtuser").text(itm.crtname);
	            $("#tstatus").text(itm.status);
	            $("#tholder").text(itm.holder);
	            $("#tranholder").val(itm.holder);
	            $("#topendt").text(itm.opendt2);
	            $("#texpirydt").text(itm.scrapdt2);
	            $("#ttotalbook").text(itm.bookqty);
	            $("#tranboxid").val(itm.boxid);

	            $("#singletran_popup_wrap").show();
	            $("#tranSaveBtn").show();
            }
	    });
	    $("#tranSaveBtn").click(function(){
	        var url = "/misc/TRBox/getTrBoxSingleTransfer.do";

            var param = $("#singletranform").serialize();
            console.log(param);
            Common.ajax("GET" , url , param , function(data){
            	Common.alert('<spring:message code="sal.alert.msg.trBoxSuccessTransferred" />' + data.data);
            	$("#tranSaveBtn").hide();
            });
	    });

    });

</script>

<!--****************************************************************************
    CONTENT START
*****************************************************************************-->

<form id="dataForm">
    <!-- essential -->
    <input type="hidden" id="reportFileName" name="reportFileName"  />
    <input type="hidden" id="viewType" name="viewType" />

    <!--param  -->
    <input type="hidden" id="BoxID" name="BoxID"  />

    <!--common param  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
</form>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>MISC</li>
        <li>TR Box</li>
        <li>TR Box Management</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>TR Box Management </h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a id="btnKeep"><span class="search"></span><spring:message code="sal.title.text.keepRelease" /></a></p></li>
            <li><p class="btn_blue"><a id="btnClose"><span class="search"></span><spring:message code="sal.title.text.closeReopen" /></a></p></li>
            <li><p class="btn_blue"><a id="btnSrch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
            <li><p class="btn_blue"><a id="btnClear"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post">

        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.boxNumber" /></th>
                <td>
                    <input type="text" title="" id="trbxnumber" name="trbxnumber" placeholder="Box Number" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.createDate" /></th>
                <td>

                    <div class="date_set w100p"><!-- date_set start -->
                    <p><input type="text" title="Create start Date" name="sdate" id="sdate" placeholder="DD/MM/YYYY" class="j_date" /></p>
                    <span><spring:message code="sal.title.to" /></span>
                    <p><input type="text" title="Create end Date" name="edate" id="edate" placeholder="DD/MM/YYYY" class="j_date" /></p>
                    </div><!-- date_set end -->

                </td>
                <th scope="row"><spring:message code="sal.text.creator" /></th>
                <td>
                    <input type="text" title="" placeholder="Creator(User Name)" class="w100p" name="crtuser" id="crtuser" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.boxStatus" /></th>
                <td>
                    <select class="multy_select w100p" multiple="multiple" id="status" name="status"></select>

                </td>
                <th scope="row"><spring:message code="sal.text.branch" /></th>
                <td>
                    <select class="w100p" name="branchid" id="branchid"></select>
                </td>
                <th scope="row"></th>
                <td></td>
            </tr>
            </tbody>
        </table><!-- table end -->
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
            <dt><spring:message code="sal.title.text.link" /></dt>
            <dd>
<!--                 <ul class="btns"> -->
<!--                     <li><p class="link_btn type2"><a href="#">menu1</a></p></li> -->
<!--                 </ul> -->
                <ul class="btns">
                    <li><p class="link_btn"><a href="/misc/TRBox/TrBoxReceive.do"><spring:message code="sal.combo.text.recv" /></a></p></li>
                    <li><p class="link_btn"><a  onclick="javascript : fn_downloadReport('EXCEL')"><spring:message code="sal.title.text.trBoxExcel" /></a></p></li>
                    <li><p class="link_btn"><a  onclick="javascript : fn_downloadReport('PDF')"><spring:message code="sal.title.text.trboxPDF" /></a></p></li>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->

    </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a id="singletranBtn"><spring:message code="sal.title.text.singleTransfer" /></a></p></li>
            <li><p class="btn_grid"><a id="updBtn"><spring:message code="sal.btn.update" /></a></p></li>
            <li><p class="btn_grid"><a id="insNew"><spring:message code="sal.title.text.new" /></a></p></li>
        </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap" style="height:500px"></div>
    </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

    <div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

		<header class="pop_header"><!-- pop_header start -->
		<h1><spring:message code="sal.title.text.viewTrBox" /></h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a id="viewclose"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->

		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code="sal.title.text.trBoxInformation" /></h2>
		</aside><!-- title_line end -->

		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:110px" />
		    <col style="width:*" />
		    <col style="width:120px" />
		    <col style="width:*" />
		    <col style="width:110px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
		    <td>
		      <span id="vboxno"></span>
		    </td>
		    <th scope="row"><spring:message code="sal.text.createAt" /></th>
		    <td id="vcrtdt"></td>
		    <th scope="row"><spring:message code="sal.text.createBy" /></th>
		    <td id="vcrtuser"></td>
		</tr>
		<tr>
		    <th scope="row"><spring:message code="sal.title.status" /></th>
		    <td id="vstatus"></td>
		    <th scope="row"><spring:message code="sal.title.text.boxHolder" /></th>
		    <td colspan="3" id="vholder"></td>
		</tr>
		<tr>
		    <th scope="row"><spring:message code="sal.title.text.openDate" /></th>
		    <td id="vopendt"></td>
		    <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
		    <td id="vexpirydt"></td>
		    <th scope="row"><spring:message code="sal.text.totalBook" /></th>
		    <td id="vtotalbook"></td>
		</tr>
		</tbody>
		</table><!-- table end -->

		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code="sal.title.text.booksInBox" /></h2>
		</aside><!-- title_line end -->

		<article class="grid_wrap"><!-- grid_wrap start -->
            <div id="view_grid_wrap" style="height:230px"></div>
		</article><!-- grid_wrap end -->
		</section><!-- pop_body end -->

	</div><!-- popup_wrap end -->


	<div id="edit_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
	    <form id="insForm" name="insForm">
	      <input type="hidden" id="loginbranchid" name="loginbranchid"/>
	      <input type="hidden" id="loginbranchcd" name="loginbranchcd"/>
	    <header class="pop_header"><!-- pop_header start -->
	        <h1><spring:message code="sal.title.text.addNewTrBox" /></h1>
	            <ul class="right_opt">
	            <li><p class="btn_blue2"><a id="insClose"><spring:message code="sal.btn.close" /></a></p></li>
	        </ul>
	    </header><!-- pop_header end -->

	    <section class="pop_body"><!-- pop_body start -->

	    <table class="type1"><!-- table start -->
	        <caption>table</caption>
	        <colgroup>
	            <col style="width:130px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
	            <tr>
	                <th scope="row"><spring:message code="sal.text.branch" /></th>
	                <td>
	                    <span id="insBrnch"></span>
	                </td>
	            </tr>
	        </tbody>
	    </table><!-- table end -->

	    <ul class="center_btns">
	        <li><p class="btn_blue2 big"><a id="insSave"><spring:message code="sal.btn.save" /></a></p></li>
	    </ul>

	    </section><!-- pop_body end -->
	  </form>
	</div><!-- popup_wrap end -->

	<div id="keep_popup_wrap" class="popup_wrap" ><!-- popup_wrap start -->

        <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="sal.title.text.bookKeepRelease" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="viewclose"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
        </header><!-- pop_header end -->
        <section class="pop_body"><!-- pop_body start -->

        <aside class="title_line"><!-- title_line start -->
        <h2><spring:message code="sal.title.text.trBoxInformation" /></h2>
        </aside><!-- title_line end -->

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
	            <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
	            <td>
	              <span id="kboxno"></span>
	            </td>
	            <th scope="row"><spring:message code="sal.text.createAt" /></th>
	            <td id="kcrtdt"></td>
	            <th scope="row"><spring:message code="sal.text.createBy" /></th>
	            <td id="kcrtuser"></td>
	        </tr>
	        <tr>
	            <th scope="row"><spring:message code="sal.title.status" /></th>
	            <td id="kstatus"></td>
	            <th scope="row"><spring:message code="sal.title.text.boxHolder" /></th>
	            <td colspan="3" id="vholder"></td>
	        </tr>
	        <tr>
	            <th scope="row"><spring:message code="sal.title.text.openDate" /></th>
	            <td id="kopendt"></td>
	            <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
	            <td id="kexpirydt"></td>
	            <th scope="row"><spring:message code="sal.text.totalBook" /></th>
	            <td id="ktotalbook"></td>
	        </tr>
		</table><!-- table end -->

        <aside class="title_line"><!-- title_line start -->
        <h2><spring:message code="sal.title.text.booksInBox" /></h2>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="keep_grid_wrap" style="height:230px"></div>
        </article><!-- grid_wrap end -->

        <ul class="left_btns">
		    <li><p class="btn_blue2"><a id="filterBtn"><spring:message code="sal.title.text.filterList" /></a></p></li>
		    <li><p class="btn_blue2"><a id="showallBtn"><spring:message code="sal.title.text.showAll" /></a></p></li>
		</ul>

        </section><!-- pop_body end -->

    </div><!-- popup_wrap end -->

    <div id="filter_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->

		<header class="pop_header"><!-- pop_header start -->
		<h1><spring:message code="sal.title.text.filterBoxBookList" /></h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
		</header><!-- pop_header end -->

		<section class="pop_body"><!-- pop_body start -->
		<form id="filterForm" name="filterForm">
		<input type="hidden" id="ksboxid" name="ksboxid" />
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
		    <th scope="row"><spring:message code="sal.text.bookNo" /></th>
		    <td colspan="3">
		    <input type="text" title="" id="ksbookno" name="ksbookno" placeholder="" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row"><spring:message code="sal.title.receiptNo" /></th>
		    <td>
		    <input type="text" title="" id="ksreceiptfr" name="ksreceiptfr" placeholder="" class="w100p" />
		    </td>
		    <th scope="row"><spring:message code="sal.title.to" /></th>
		    <td>
		    <input type="text" title="" id="ksreceiptto" name="ksreceiptto" placeholder="" class="w100p" />
		    </td>
		</tr>
		</tbody>
		</table><!-- table end -->
		</form>
		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="keepBtnsrch"><spring:message code="sal.btn.search" /></a></p></li>
		    <li><p class="btn_blue2 big"><a id="keepBtnclr"><spring:message code="sal.btn.clear" /></a></p></li>
		</ul>
		</section><!-- pop_body end -->

	</div><!-- popup_wrap end -->
	<div id="close_popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

		<header class="pop_header"><!-- pop_header start -->
		<h1><spring:message code="sal.title.text.trBoxCloseReopen" /></h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a id="closePopupCloBtn"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
		</header><!-- pop_header end -->

		<section class="pop_body"><!-- pop_body start -->

		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code="sal.title.text.trBoxInformation" /></h2>
		</aside><!-- title_line end -->

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
               <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
               <td>
                 <span id="cboxno"></span>
               </td>
               <th scope="row"><spring:message code="sal.text.createAt" /></th>
               <td id="ccrtdt"></td>
               <th scope="row"><spring:message code="sal.text.createBy" /></th>
               <td id="ccrtuser"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.status" /></th>
               <td id="cstatus"></td>
               <th scope="row"><spring:message code="sal.title.text.boxHolder" /></th>
               <td colspan="3" id="cholder"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.text.openDate" /></th>
               <td id="copendt"></td>
               <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
               <td id="cexpirydt"></td>
               <th scope="row"><spring:message code="sal.text.totalBook" /></th>
               <td id="ctotalbook"></td>
           </tr>
           </tbody>
           </table><!-- table end -->


		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="closeBtn"><spring:message code="sal.title.text.closeBox" /></a></p></li>
		</ul>
		</section><!-- pop_body end -->

		</div><!-- popup_wrap end -->

		<div id="update_popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

			<header class="pop_header"><!-- pop_header start -->
			<h1><spring:message code="sal.title.text.trBoxUpdateInfo" /></h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a id="updateCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
			</ul>
			</header><!-- pop_header end -->

			<section class="pop_body"><!-- pop_body start -->

			<aside class="title_line"><!-- title_line start -->
			<h2><spring:message code="sal.title.text.trBoxInformation" /></h2>
			</aside><!-- title_line end -->

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
               <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
               <td>
                 <span id="uboxno"></span>
               </td>
               <th scope="row"><spring:message code="sal.text.createAt" /></th>
               <td id="ucrtdt"></td>
               <th scope="row"><spring:message code="sal.text.createBy" /></th>
               <td id="ucrtuser"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.status" /></th>
               <td id="ustatus"></td>
               <th scope="row"><spring:message code="sal.title.text.boxHolder" /></th>
               <td colspan="3" id="uholder"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.text.openDate" /></th>
               <td id="uopendt"></td>
               <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
               <td id="uexpirydt"></td>
               <th scope="row"><spring:message code="sal.text.totalBook" /></th>
               <td id="utotalbook"></td>
           </tr>
           </tbody>
        </table><!-- table end -->

		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code="sal.alert.msg.transferInformation" /></h2>
		</aside><!-- title_line end -->

		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row"><spring:message code="sal.title.text.scrapDate" /></th>
		    <td>
		    <input type="text" title="Create start Date" id="uscrapdt" name="uscrapdt" placeholder="DD-MM-YYYY" class="j_date" />
		    </td>
		</tr>
		</tbody>
		</table><!-- table end -->


		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="updSaveBtn">Save</a></p></li>
		</ul>
		</section><!-- pop_body end -->

   	</div><!-- popup_wrap end -->

   	<div id="singletran_popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->

       <header class="pop_header"><!-- pop_header start -->
       <h1><spring:message code="sal.title.text.trBoxhyInfomation" /></h1>
       <ul class="right_opt">
           <li><p class="btn_blue2"><a id="transferCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
       </ul>
       </header><!-- pop_header end -->

       <section class="pop_body"><!-- pop_body start -->

       <aside class="title_line"><!-- title_line start -->
       <h2><spring:message code="sal.title.text.trBoxInformation" /></h2>
       </aside><!-- title_line end -->
       <form id="singletranform" name="singletranform">
       <input type="hidden" name="tranholder" id="tranholder"/>
       <input type="hidden" name="tranboxid" id="tranboxid"/>
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
               <th scope="row"><spring:message code="sal.title.text.boxNo" /></th>
               <td>
                 <span id="tboxno"></span>
               </td>
               <th scope="row"><spring:message code="sal.text.createAt" /></th>
               <td id="tcrtdt"></td>
               <th scope="row"><spring:message code="sal.text.createBy" /></th>
               <td id="tcrtuser"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.status" /></th>
               <td id="tstatus"></td>
               <th scope="row"><spring:message code="sal.title.text.boxHolder" /></th>
               <td colspan="3" id="tholder"></td>
           </tr>
           <tr>
               <th scope="row"><spring:message code="sal.title.text.openDate" /></th>
               <td id="topendt"></td>
               <th scope="row"><spring:message code="sal.text.expiryDate" /></th>
               <td id="texpirydt"></td>
               <th scope="row"><spring:message code="sal.text.totalBook" /></th>
               <td id="ttotalbook"></td>
           </tr>
           </tbody>
        </table><!-- table end -->

        <aside class="title_line"><!-- title_line start -->
        <h2><spring:message code="sal.alert.msg.transferInformation" /></h2>
        </aside><!-- title_line end -->

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.alert.msg.transferTo" /></th>
            <td>
            <select id="tbrnch" name="tbrnch" class="w100p" ></select>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.courier" /></th>
            <td>
            <select id="tcourier" name="tcourier" class="w100p"></select>
            </td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>

        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a id="tranSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
        </ul>
        </section><!-- pop_body end -->

    </div><!-- popup_wrap end -->

</section><!-- content end -->
