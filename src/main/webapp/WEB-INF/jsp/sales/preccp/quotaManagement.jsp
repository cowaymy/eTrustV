<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<section id="content">
    <ul class="path"></ul>
    <aside class="title_line">
        <p class="fav"><a></a><h2>Quota Management</h2></p>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <input class="chkAccess" type="hidden" value ="1">
                <li><p class="btn_blue btnUploadQuota" id="btnUploadQuota"><a>Upload Quota</a></p></li>
            </c:if>

            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                <input class="chkAccess" type="hidden" value ="2">
                <li><p class="btn_blue btnViewQuota" id="btnViewQuota"><a>View Quota</a></p></li>
            </c:if>
            <li style="display:none;" id="btnSearch"><p class="btn_blue"><a><span class="search"></span>Search</a></p></li>
            <li style="display:none;" id="btnClear"><p class="btn_blue"><a><span class="clear"></span>Clear</a></p></li>
            <li style="display:none;" id="btnSearchTransfer"><p class="btn_blue"><a><span class="search"></span>Search</a></p></li>
            <li style="display:none;" id="btnClearTransfer"><p class="btn_blue"><a><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
        <div id="div1" class="detect" style="display:none;">
              <form id="quotaManagementForm">
                    <table class="type1">
                        <colgroup>
                            <col style="width: 150px;"/>
                            <col style="width: *;"/>
                            <col style="width: 150px;"/>
                            <col style="width: *;"/>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>Batch No</th>
                                <td><input class="w100p" type="text" name="batchNo" id="batchNo" /></td>

                                <th>Create Date</th>
                                <td>
                                    <div class="date_set w100p">
                                        <p><input name="start" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                                        <span>To</span>
                                        <p><input name="end" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <th>Creator</th>
                                <td><input class="w100p" type="text" name="creator"></td>

                                <th>Batch Status</th>
                                <td>
                                    <select class="w100p" name="quotaStus">
                                        <option value="">Choose One</option>
                                        <option value="4">Completed</option>
                                        <option value="114">Forfeited</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
            </form>

            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                            <li><p class="link_btn type2"><a id="btnUpload">New Upload</a></p></li>
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <br/>
            <div id="quotaManagementGrid"></div>
       </div>


       <div id="div2" class="detect" style="display:none;">
               <form id="transferQuotaForm">
                     <table class="type1">
                         <colgroup>
                             <col style="width: 150px;"/>
                             <col style="width: *;"/>
                             <col style="width: 150px;"/>
                             <col style="width: *;"/>
                         </colgroup>
                         <tbody>
                             <tr>
                                 <th>Member Type</th>
                                 <td>
                                     <select class="w100p checkTransfer" name="memType" id="memType">
                                         <option value="">Choose One</option>
                                         <option value="1">HP</option>
                                         <option value="2">CD</option>
                                         <option value="7">HT</option>
                                     </select>
                                 </td>

				                  <th>Quota Year</th>
				                  <td><select class="w100p checkTransfer" name="year" id="year"></select></td>

				                  <th>Quota Month</th>
				                  <td><select class="w100p checkTransfer" name="month" id="month"></select></td>
                             </tr>

                             <tr>
                                 <th>Dept Code</th>
                                 <td><input class="w100p checkTransfer" type="text" name="deptCode" id="deptCode"></td>

                                 <th>Group Code</th>
                                 <td><input class="w100p checkTransfer" type="text" name="grpCode" id="grpCode"></td>

                                 <th>Org Code</th>
                                 <td><input class="w100p checkTransfer" type="text" name="orgCode" id="orgCode"></td>
                             </tr>
                         </tbody>
                     </table>
             </form>
             <br/>
             <div id="transferQuotaGrid"></div>
       </div>
</section>


<script>

    let div1Open = false, div2Open = false;

    $("#batchNo").unbind().bind("change keyup", function(e) {
        $(this).val($(this).val().replace(/[\D]/g,"").trim());
    });

    const clearForm = (formId) => {
        document.getElementById(formId).reset();
        setOrganizationInfo();
        openDiv();
    }

    const month = document.getElementById("month"), year = document.getElementById("year");

    const getYear = () =>{
        year.innerHTML = "";
        year.innerHTML += "<option value=''>Choose One</option>";
        fetch("/sales/ccp/selectYearList.do")
        .then(r=>r.json())
        .then(data=>{
            for(let i = 0; i < data.length; i++) {
                const {codeName, codeId} = data[i]
                year.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
            }
        })
    }

    const getMonth = () =>{
        month.innerHTML = "";
        month.innerHTML += "<option value=''>Choose One</option>";
        fetch("/sales/ccp/selectMonthList.do")
        .then(r=>r.json())
        .then(data=>{
            for(let i = 0; i < data.length; i++) {
                const {codeName, codeId} = data[i]
                month.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
            }
        })
    }

    const setOrganizationInfo = () => {
        if("${orgCode}") $("#orgCode").val("${orgCode}".trim());
        if("${grpCode}") $("#grpCode").val("${grpCode}".trim());
        if("${deptCode}") $("#deptCode").val("${deptCode}".trim());
        if("${memberType}") {
        	$("#memType").val("${memberType}".trim());
            $("#memType").attr("class", "w100p readonly checkTransfer");
            $("#memType").attr("disabled", "disabled");
        }

        switch("${SESSION_INFO.memberLevel}") {
        case "4":
            $("#orgCode").attr("class", "w100p readonly checkTransfer");
            $("#orgCode").attr("readonly", "readonly");
            $("#grpCode").attr("class", "w100p readonly checkTransfer");
            $("#grpCode").attr("readonly", "readonly");
            $("#deptCode").attr("class", "w100p readonly checkTransfer");
            $("#deptCode").attr("readonly", "readonly");
            break;
        case "3":
            $("#orgCode").attr("class", "w100p readonly checkTransfer");
            $("#orgCode").attr("readonly", "readonly");
            $("#grpCode").attr("class", "w100p readonly checkTransfer");
            $("#grpCode").attr("readonly", "readonly");
            $("#deptCode").attr("class", "w100p readonly checkTransfer");
            $("#deptCode").attr("readonly", "readonly");
            break;
        case "2":
            $("#orgCode").attr("class", "w100p readonly checkTransfer");
            $("#orgCode").attr("readonly", "readonly");
            $("#grpCode").attr("class", "w100p readonly checkTransfer");
            $("#grpCode").attr("readonly", "readonly");
            break;
        case "1":
            $("#orgCode").attr("class", "w100p readonly checkTransfer");
            $("#orgCode").attr("readonly", "readonly");
            break;
        default:
            break;
          }
    }

    const openDiv = () =>{
        document.getElementById("div1").style.display = div1Open ? "": "none";
        document.getElementById("div2").style.display = div2Open ? "": "none";

        document.querySelector(".btnUploadQuota a").style.backgroundColor = !div1Open ? "#9ea9b4" : "rgb(37, 82, 124)";
        document.querySelector(".btnViewQuota a").style.backgroundColor = !div2Open ? "#9ea9b4" : "rgb(37, 82, 124)";

        if(div1Open) {
            $("#btnSearch").show();
            $("#btnClear").show();
            $("#btnSearchTransfer").hide();
            $("#btnClearTransfer").hide();
        }

        if(div2Open) {
            getYear();
            getMonth();
            $("#btnSearchTransfer").show();
            $("#btnClearTransfer").show();
            $("#btnSearch").hide();
            $("#btnClear").hide();
        }
    }

    if(document.querySelector(".chkAccess").value == "2"){
        div1Open = false;
        div2Open = true;
     }else{
        div1Open = true;
        div2Open = false;
     }

     openDiv();
     setOrganizationInfo();

     $("#btnUploadQuota").click((e)=>{
         e.preventDefault();
         div1Open = true;
         div2Open = false;
         openDiv();
    });

     if(div1Open){

		     const quotaManagementGrid =  GridCommon.createAUIGrid('quotaManagementGrid',[
			      {
			          dataField : 'batchNo', headerText : 'Batch No', width: "10%"
			      },
			      {
			          dataField : 'batchStatus', headerText : 'Batch Status', width: "10%"
			      },
			      {
			          dataField : 'total', headerText : 'No. of Quota', width: "10%"
			      },
			      {
			          dataField : 'batchUploadDate', headerText : 'Batch Upload Date', width: "15%"
			      },
			      {
			          dataField : 'creator', headerText : 'Creator', width: "10%"
			      },
			      {
		              dataField : 'remark', headerText : 'Remark', width: "20%"
		          },
			      {
		              dataField : 'batchUpdateDate', headerText : 'Batch Update Date', width: "15%"
		          },
			      {
		              dataField : 'updator', headerText : 'Updator', width: "10%"
		          },
		          {
		              dataField: "btnText",
		              headerText : 'Action',
		              editable: false,
		              width: '15%',
		              renderer: {
		                  type: "TemplateRenderer"
		              },
		              labelFunction: function(r, c, v, h, item) {
		            	  return "<button " + `style="border: 1px solid #aaaaaa;display: inline-block;padding: 4px 2em;" ` + (item.batchStatus == "Forfeited" ? "disabled" : "") + " onclick='((no) => Common.popupDiv(`/sales/ccp/forfeitQuota.do`, {batchId: no}, null, true , null))(" + item.batchNo + ")'>Forfeit</button>"
		              }
		      }],'',
		     {
				      usePaging: true,
				      pageRowCount: 50,
				      editable: false,
				      showRowNumColumn: true,
				      wordWrap: true,
				      showStateColumn: false
			 });

		     AUIGrid.bind(quotaManagementGrid, "cellDoubleClick", (event) => {
		    	  let batchId = event.item.batchNo;
		          Common.popupDiv("/sales/ccp/viewQuota.do", {batchId}, null, true , null);
		    });

		    const generateGrid = () =>{
		        Common.showLoader();
		        fetch("/sales/ccp/selectQuota.do?"+ $("#quotaManagementForm").serialize())
		        .then(r=>r.json())
		        .then(data => {
		            Common.removeLoader();
		            AUIGrid.setGridData(quotaManagementGrid, data.map(e => ({...e, btnText: "Forfeit"})));
		        });
		    }

		    $("#btnSearch").click((e)=>{
		        e.preventDefault();
		        generateGrid();
		    });

		    $("#btnUpload").click((e)=>{
		         e.preventDefault();
		         Common.popupDiv("/sales/ccp/uploadNewQuota.do", null, null, true , null);
		    });

		    $("#btnClear").click((e)=> {
		        e.preventDefault();
		        clearForm("quotaManagementForm");
		        AUIGrid.clearGridData(quotaManagementGrid);
		    });
     }


    const transferQuotaGrid =  GridCommon.createAUIGrid('transferQuotaGrid',[
     {
         dataField : 'deptCode', headerText : 'Dept Code', width: "10%"
     },
     {
         dataField : 'grpCode', headerText : 'Group Code', width: "10%"
     },
     {
         dataField : 'orgCode', headerText : 'Org Code', width: "10%"
     },
     {
         dataField : 'newQuota', headerText : 'No. of Quota', width: "10%"
     },
     {
         dataField : 'usageQuota', headerText : 'No. of Usage', width: "10%"
     },
     {
         dataField : 'balanceQuota', headerText : 'Balance', width: "10%"
     },
     {
         dataField : 'forfeitQuota', headerText : 'Forfeit', width: "10%"
     },
     {
         dataField : 'month', headerText : 'Quota Month', width: "10%"
     },
     {
         dataField : 'year', headerText : 'Quota Year', width: "10%"
     },
     {
         dataField: "btnText",
         headerText : 'Transfer Balance Quota',
         editable: false,
         width: '20%',
         renderer: {
             type: "TemplateRenderer"
         },
         labelFunction: function(r, c, v, h, item) {
             return "<button " + `style="border: 1px solid #aaaaaa;display: inline-block;padding: 4px 2em;" ` + (item.deptCode? "disabled" : "") + " onclick='((no, no2,no3, no4) => Common.popupDiv(`/sales/ccp/transferQuota.do`, {orgCode: no, grpCode: no2, year: no3, month: no4}, null, true , null))(" + `"` + item.orgCode  + `",` + `"`+ item.grpCode +`",` + `"` + item.year + `",` + `"` + item.month + `"`+ ")'>Transfer</button>"
         }
	 }],'',
	{
         usePaging: true,
         pageRowCount: 50,
         editable: false,
         showRowNumColumn: true,
         wordWrap: true,
         showStateColumn: false,
         showFooter : true
	});

    let footerLayout = [{
           labelText: "Total : ",
           positionField: "orgCode"
      },{
	   	   dataField: "newQuota",
	   	   positionField: "newQuota",
	   	   operation: "SUM",
	   	   formatString: "###0",
	   	   style: "aui-grid-my-footer-sum-total"
      },{
           dataField: "usageQuota",
           positionField: "usageQuota",
           operation: "SUM",
           formatString: "###0",
           style: "aui-grid-my-footer-sum-total"
      },{
           dataField: "balanceQuota",
           positionField: "balanceQuota",
           operation: "SUM",
           formatString: "###0",
           style: "aui-grid-my-footer-sum-total"
      },{
           dataField: "forfeitQuota",
           positionField: "forfeitQuota",
           operation: "SUM",
           formatString: "###0",
           style: "aui-grid-my-footer-sum-total"
      }];

    const generateTransferGrid = () =>{
        Common.showLoader();
        fetch("/sales/ccp/selectViewQuotaDetails.do?"+ $("#transferQuotaForm").serialize())
        .then(r=>r.json())
        .then(data => {
            Common.removeLoader();
            AUIGrid.setFooter(transferQuotaGrid, footerLayout);
            AUIGrid.setGridData(transferQuotaGrid, data.map(e => ({...e, btnText: "Transfer"})));
        });
    }

    $("#btnViewQuota").click((e)=>{
        e.preventDefault();
        div1Open = false;
        div2Open = true;
        openDiv();
        AUIGrid.resize(transferQuotaGrid, 1300, 400);
   });

    $("#btnSearchTransfer").click((e)=>{
        e.preventDefault();

        let check = [...document.querySelectorAll(".checkTransfer")].some(r=> {
            if(r.value.trim().length){
                return true
             }
        });

        if(check){
            AUIGrid.resize(transferQuotaGrid, 1300, 400);
            generateTransferGrid();
        }else{
        	Common.alert("Please fill in one of searching criteria.")
        }
    });


    $("#btnClearTransfer").click((e)=> {
        e.preventDefault();
    	clearForm("transferQuotaForm");
    	AUIGrid.clearGridData(transferQuotaGrid);
    });




</script>
