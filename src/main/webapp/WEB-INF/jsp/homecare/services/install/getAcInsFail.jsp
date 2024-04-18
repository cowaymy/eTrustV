<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>
<script src="https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js"></script>
<style>
      #sirimUploadContainer {
        margin-bottom: 30px;
      }

      #installUploadContainer > h5:not(:first-child) {
        margin-top: 30px;
      }

      #qr-reader-cont {
        position: fixed !important;
        width: 100vw;
        height: 100vh;
        top: 0;
        left: 0;
        display: none;
        z-index: 100;
        align-items: center;
        background: rgba(0,0,0,0.5);
      }

      .btn-tag {
        background-color: #ECEFF1;
        text-transform: capitalize !important;
        margin-bottom: 10px;
        box-shadow: none;
      }

      .btn-tag:hover {
        box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .25), 0 3px 10px 5px rgba(0, 0, 0, 0.05) !important;
      }

      .grid-item {
        width: 50%;
      }

      .grid-item img {
        width: 100%;
      }

     .foto:before {
        content: url("data:image/svg+xml, %3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22currentColor%22%20class%3D%22bi%20bi-images%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M4.502%209a1.5%201.5%200%201%200%200-3%201.5%201.5%200%200%200%200%203z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M14.002%2013a2%202%200%200%201-2%202h-10a2%202%200%200%201-2-2V5A2%202%200%200%201%202%203a2%202%200%200%201%202-2h10a2%202%200%200%201%202%202v8a2%202%200%200%201-1.998%202zM14%202H4a1%201%200%200%200-1%201h9.002a2%202%200%200%201%202%202v7A1%201%200%200%200%2015%2011V3a1%201%200%200%200-1-1zM2.002%204a1%201%200%200%200-1%201v8l2.646-2.354a.5.5%200%200%201%20.63-.062l2.66%201.773%203.71-3.71a.5.5%200%200%201%20.577-.094l1.777%201.947V5a1%201%200%200%200-1-1h-10z%22%2F%3E%0A%3C%2Fsvg%3E");
        margin-right: 10px;
        transform: translate(0, 10%);
      }

      .kamera:before {
        content: url("data:image/svg+xml, %3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22currentColor%22%20class%3D%22bi%20bi-camera%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M15%2012a1%201%200%200%201-1%201H2a1%201%200%200%201-1-1V6a1%201%200%200%201%201-1h1.172a3%203%200%200%200%202.12-.879l.83-.828A1%201%200%200%201%206.827%203h2.344a1%201%200%200%201%20.707.293l.828.828A3%203%200%200%200%2012.828%205H14a1%201%200%200%201%201%201v6zM2%204a2%202%200%200%200-2%202v6a2%202%200%200%200%202%202h12a2%202%200%200%200%202-2V6a2%202%200%200%200-2-2h-1.172a2%202%200%200%201-1.414-.586l-.828-.828A2%202%200%200%200%209.172%202H6.828a2%202%200%200%200-1.414.586l-.828.828A2%202%200%200%201%203.172%204H2z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M8%2011a2.5%202.5%200%201%201%200-5%202.5%202.5%200%200%201%200%205zm0%201a3.5%203.5%200%201%200%200-7%203.5%203.5%200%200%200%200%207zM3%206.5a.5.5%200%201%201-1%200%20.5.5%200%200%201%201%200z%22%2F%3E%0A%3C%2Fsvg%3E");
        margin-right: 10px;
        transform: translate(0, 10%);
      }

      .tangkap:before {
         content: url("data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22%23ffffff%22%20class%3D%22bi%20bi-aspect-ratio%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M0%203.5A1.5%201.5%200%200%201%201.5%202h13A1.5%201.5%200%200%201%2016%203.5v9a1.5%201.5%200%200%201-1.5%201.5h-13A1.5%201.5%200%200%201%200%2012.5v-9zM1.5%203a.5.5%200%200%200-.5.5v9a.5.5%200%200%200%20.5.5h13a.5.5%200%200%200%20.5-.5v-9a.5.5%200%200%200-.5-.5h-13z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M2%204.5a.5.5%200%200%201%20.5-.5h3a.5.5%200%200%201%200%201H3v2.5a.5.5%200%200%201-1%200v-3zm12%207a.5.5%200%200%201-.5.5h-3a.5.5%200%200%201%200-1H13V8.5a.5.5%200%200%201%201%200v3z%22%2F%3E%0A%3C%2Fsvg%3E");
         margin-right: 10px;
         transform: translate(0, 10%);
      }
</style>

<div style="min-height: 100vh; flex-direction:column;" class="d-flex align-items-center mainBackground" id="page1">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Choose Failed Reason</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>

								<div class="form-outline col">
								            <h5>&nbsp;Failed Location :</h5>
								            <select class="form-control" id="failLoc">
								                    <option value="" selected>--Select Options--</option>
								                    <option value="8000">FAIL AT LOCATION</option>
								                    <option value="8100">FAIL BEFORE ARRIVE LOCATION</option>
								            </select>
								</div>
								<div class="form-outline mt-3 col">
								            <h5>&nbsp;Failed Reason :</h5>
								            <select class="form-control" id="failReason"></select>
								</div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackMain" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Back</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage2" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Next</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>

<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page2">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Required Photos</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>
                               <div id="installUploadContainer"></div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage1" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Back</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage3" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Next</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>


<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page3">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Verification</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                                <div class="row">
                                      <div class="col-6"><h4>Installation Note: </h4></div>
                                      <div class="col-6"><h4 class="font-weight-bold">${installationInfo.installEntryNo}</h4></div>
                                </div>
                                <div class="row">
                                          <div class="col-6"><h5>Order No: </h5></div>
                                          <div class="col-6"><h5>${installationInfo.salesOrdNo}</h5></div>
                                 </div>
                                <div class="row">
                                     <div class="col-6"><h5>Order Date: </h5></div>
                                     <div class="col-6"><h5 id="salesDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Appointment Date: </h5></div>
                                     <div class="col-6"><h5 id="doDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Failed Location: </h5></div>
                                     <div class="col-6"><h5 id="location"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Failed Reason: </h5></div>
                                     <div class="col-6"><h5 id="reason"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Remark:</h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-12"><textarea id="remark"  rows="4" cols="50"></textarea></div>
                                </div>
                                <div class="row" style="display:none;" id="failTitle">
                                     <div class="col-6"><h4 class="text-danger">Failed: </h4></div>
                                </div>
                                <div id="displayUploadContainer"></div>

                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage2" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Back</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnSubmit" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Submit</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>

<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert" hidden />
<div class="modal" id="myModalAlert" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgAlert" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal"  style="width:100%;background:#4f90d6 !important;">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<input type="button" id="alertModalClick2" data-toggle="modal" data-target="#myModalAlert2" hidden />
<div class="modal" id="myModalAlert2" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgAlert2" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="reload()" style="width:100%;background:#4f90d6 !important;">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javaScript">

	fetch("/homecare/services/install/selectInstallationInfo.do?insNo=${insNo}")
	.then(r => r.json())
	.then(resp => {
	    if(resp.dupCheck){
	        window.location = "/homecare/services/install/getAcPreInsResult.do?insNo=${insNo}";
	    }
	});

     const iOS = /(iPad|iPhone|iPod)/g.test(navigator.userAgent);

     const reload = () => {window.location = "/homecare/services/install/getAcPreInsResult.do?insNo=${insNo}";}

	$("#salesDt").text($("#salesDt").text() + moment("${installationInfo.salesDt}").format("DD-MM-YYYY"));
	$("#doDt").text($("#doDt").text() + moment("${installationInfo.installDt}").format("DD-MM-YYYY"));


	$(function(){
	    let x = document.querySelector('.bottom_msg_box');
	     x.style.display = "none";
	});

	const openPage1 = () => {
		document.querySelector("#page2").classList.remove("d-flex");
		document.querySelector("#page2").style.display = "none";

	    document.querySelector("#page3").classList.remove("d-flex");
	    document.querySelector("#page3").style.display = "none";

		document.querySelector("#page1").classList.add("d-flex");
        document.querySelector("#page1").style.display = "";
	}

	const openPage2 = () => {
        document.querySelector("#page1").classList.remove("d-flex");
        document.querySelector("#page1").style.display = "none";

        document.querySelector("#page3").classList.remove("d-flex");
        document.querySelector("#page3").style.display = "none";

        document.querySelector("#page2").classList.add("d-flex");
        document.querySelector("#page2").style.display = "";
    }

	const openPage3 = () => {
        document.querySelector("#page1").classList.remove("d-flex");
        document.querySelector("#page1").style.display = "none";

        document.querySelector("#page2").classList.remove("d-flex");
        document.querySelector("#page2").style.display = "none";

        document.querySelector("#page3").classList.add("d-flex");
        document.querySelector("#page3").style.display = "";

        displayImageUpload(document.getElementById("displayUploadContainer"));
        const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
        let flag = false;
        for(let i = 0; i < installUploadContainer.length; i++){
            if(installUploadContainer[i].files[0]){
                   flag=true;
            }
        }
        if(flag){
        	const failTitle =document.getElementById("failTitle");
        	failTitle.style.display="";
        }
    }

	const displayImageUpload = (el) => {
        let uploadImg = document.querySelectorAll('img.install');
        let resetImg = document.getElementById('displayUploadContainer');

        resetImg.innerHTML = "";

        const grid = document.createElement("div");
        grid.classList.add("grid");


        for(let i=0; i < uploadImg.length; i++){
            const gridItem = document.createElement("div");
            gridItem.classList.add("grid-item");
            gridItem.classList.add("card");

            const cardBody = document.createElement("div");
            cardBody.classList.add("card-body");

	        const displayImg = document.createElement("img");
	         displayImg.classList.add("display");

	         if(uploadImg[i].src){
	        	  displayImg.src = uploadImg[i].src;
	        	  cardBody.appendChild(displayImg);
	              gridItem.appendChild(cardBody);
	              grid.appendChild(gridItem);
	         }
        }

        el.appendChild(grid);

        $('.grid').masonry({
          itemSelector: '.grid-item'
        });
	}


	  const addImageUpload = (el, titleName) => {
	        //image upload

	        const title = document.createElement("h5");
	        title.innerHTML = "&nbsp;" + titleName + " : ";

	        const photoDiv = document.createElement("div");
	        photoDiv.style.display = "flex";

	        const aElement = document.createElement("a");
	        aElement.classList.add("btn");
	        aElement.classList.add("btn-tag");
	        aElement.classList.add("btn-rounded");
	        aElement.classList.add("m-2");
	        aElement.classList.add("foto");
	        aElement.style.display = "flex";
	        aElement.style.alignItems = "center";
	        aElement.innerText = "Photo";

	        const imageCont = document.createElement("div");
	        imageCont.classList.add("p-2");
	        imageCont.style.border = "1px solid grey";
	        imageCont.style.display = "none";

	        const image = document.createElement("img");
	        image.style.width = "100%";
	        image.classList.add("install");

	        const upload = document.createElement("input")
	        upload.type = "file";
	        upload.style.display="none";
	        upload.accept = ".jpeg,.png,.jpg";

	        upload.onchange = (e) => {
	            if(e.target.files[0].type !="image/jpeg" && e.target.files[0].type !="image/png"){
	                if(!iOS){
	                    document.getElementById("MsgAlert").innerHTML =  "Only can upload images file with .png / .jpg";
	                    $("#alertModalClick").click();
	                }
	            }
	            else{
	                createImageBitmap(e.target.files[0]).then((imageBit) => {
	                    const canvas = document.createElement("canvas")
	                    canvas.width = imageBit.width
	                    canvas.height = imageBit.height
	                    const ctx = canvas.getContext('2d')
	                    ctx.drawImage(imageBit, 0, 0)
	                    canvas.toBlob((b) => {
	                        const f = new File([b], 'upload.jpg');
	                        if(f.size > 2048000){
	                            document.getElementById("MsgAlert").innerHTML =  "Cannot upload the image more than 2MB.";
	                            $("#alertModalClick").click();
	                            return
	                        }
	                        const container = new DataTransfer();
	                        container.items.add(f);
	                        image.src = URL.createObjectURL(e.target.files[0]);
	                        e.target.files = container.files;
	                        imageCont.style.display = "";
	                    }, e.target.files[0].type, 0.5)
	                })
	            }
	        }

	        el.appendChild(title);
	        el.appendChild(photoDiv);
	        photoDiv.appendChild(aElement);
	        imageCont.appendChild(image);
	        el.appendChild(upload);
	        el.appendChild(imageCont)


	        aElement.onclick = () => {
	            upload.click();
	        }

	        //camera
	        const openCamera = document.createElement("button");
	        const screenshot = document.createElement("button");
	        const aElement2 = document.createElement("a");
	        aElement2.classList.add("btn");
	        aElement2.classList.add("btn-tag");
	        aElement2.classList.add("btn-rounded");
	        aElement2.style.display = "flex";
	        aElement2.style.alignItems = "center";
	        aElement2.classList.add("m-2");
	        aElement2.classList.add("kamera");
	        aElement2.innerText = "Camera";

	        const aElement3 = document.createElement("a");
	        aElement3.classList.add("btn");
	        aElement3.classList.add("btn-tag");
	        aElement3.classList.add("btn-rounded");
	        aElement3.style.display = "flex";
	        aElement3.style.alignItems = "center";
	        aElement3.classList.add("m-2");
	        aElement3.classList.add("tangkap");
	        aElement3.classList.add("bg-danger");
	        aElement3.classList.add("text-light");
	        aElement3.classList.add("p-3");
	        aElement3.innerText = "Capture";

	        openCamera.style.display = "none";
	        screenshot.style.display = "none";
	        aElement3.style.display = "none";

	        el.insertBefore(openCamera, imageCont);
	        el.insertBefore(screenshot, imageCont);

	        photoDiv.appendChild(aElement2);
	        photoDiv.appendChild(aElement3);

	        aElement2.onclick = () => {
	            navigator.mediaDevices.getUserMedia({video: {facingMode: 'environment'}})
	            .then(s => {
	                aElement.style.display = "none";
	                aElement2.style.display = "none";
	                aElement3.style.display = "flex";
	                const video = document.createElement("video");
	                video.autoplay = true;
	                video.playsInline = true;
	                video.muted = true;
	                video.style.width = "100%";
	                video.style.position  = "absolute";
	                const vidCont = document.createElement("div")
	                vidCont.appendChild(video)
	                vidCont.style.position = "relative";
	                vidCont.style.overflow = "hidden";
	                const c = document.createElement("canvas")
	                c.style.display = "none";
	                el.appendChild(c);
	                video.srcObject = s;
	                video.addEventListener("loadedmetadata", () => {
	                    vidCont.style.height = video.clientHeight + 'px'
	                })
	                el.insertBefore(vidCont, imageCont);
	                video.play();
	                aElement3.onclick = () => {
	                    aElement3.style.display = "none";
	                    aElement.style.display = "flex";
	                    aElement2.style.display = "flex";
	                    c.height = video.videoHeight;
	                    c.width = video.videoWidth;
	                    const ctx = c.getContext('2d');
	                    ctx.drawImage(video, 0, 0, c.width, c.height);
	                    image.src = c.toDataURL();
	                    c.toBlob(b => {
	                        const f = new File([b], 'upload.jpg');
	                        const container = new DataTransfer();
	                        container.items.add(f);
	                        upload.files = container.files;
	                        s.getTracks().forEach(t => t.stop());
	                        imageCont.style.display = "";
	                        c.remove();
	                        vidCont.remove()
	                    }, 'image/jpeg', 0.5)
	                }
	            })
	        }
	 }

    for (let i = 0; i < 4; i++) {
    	let titleName = "Attachment "+ (i+1);
        addImageUpload(document.getElementById("installUploadContainer") , titleName)
    }

    const failLoc = document.getElementById("failLoc");
    const failReason = document.getElementById("failReason");
    getErrorCode = () => {
	    	failReason.innerHTML = "";
	        if(!document.querySelector("#failLoc option:checked").value){
	            failReason.innerHTML += "<option value=''>--Select Reason--</option>";
	        }else{
		    	fetch("/homecare/services/install/selectFailChild.do?groupCode=" + document.querySelector("#failLoc option:checked").value)
		    	.then(r => r.json())
		    	.then(d => {
		    		for(let i = 0; i < d.length; i++) {
		    			const {codeName, codeId} = d[i]
		    			failReason.innerHTML += "<option value=" + codeId + ">" + codeName + "</option>"
		    		}
		    	})
	        }
    }
    getErrorCode()
    failLoc.onchange = getErrorCode

    $("#btnBackMain").click(e => {
        e.preventDefault()
	    window.top.Common.showLoader();
	    window.top.location.href = '/homecare/services/install/getAcInstallationInfo.do?insNo=${insNo}';
    })

    $("#btnBackPage1").click(e => {
        e.preventDefault()
        openPage1();
    })

     $("#btnBackPage2").click(e => {
        e.preventDefault()
        openPage2();
    })

    $("#btnNextPage2").click(e => {
        e.preventDefault()
        openPage2();
    })

    $("#btnNextPage3").click(e => {
        e.preventDefault()
        if(!$("#failLoc option:selected").val()){
       	    $("#location").text("-");
            $("#reason").text("-");
        }else{
            $("#location").text($("#failLoc option:selected").text());
            $("#reason").text($("#failReason option:selected").text());
        }

        openPage3();
    })


    let attachment = 0;
    const insertPreInsFail = () => {
    	const insNo = "${insNo}", failLoc = document.querySelector("#failLoc").value, failReason = $("#failReason").val() , remark = document.querySelector("#remark").value;
        fetch("/homecare/services/install/insertPreInsFail.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                  insNo,
                  failLoc,
                  failReason,
                  attachment,
                  remark
            })
        })
        .then(() => {
        	document.getElementById("MsgAlert2").innerHTML =  "Pre-installation created! You may proceed to close this page.";
            $("#alertModalClick2").click();
        })
        .catch(() => {
            document.querySelector("#btnSubmit").style.display="";
            document.querySelector("#btnBackPage2").style.display="";
        	document.getElementById("MsgAlert").innerHTML =  "Pre-installation insert failed!";
        	$("#alertModalClick").click();
        })
    }

    $("#btnSubmit").click(e => {
    	e.preventDefault();
        document.querySelector("#btnBackPage2").style.display="none";
        document.querySelector("#btnSubmit").style.display="none";
        fetch("/homecare/services/install/selectInstallationInfo.do?insNo=${insNo}")
        .then(r => r.json())
        .then(resp => {
            if(!resp.dupCheck){
            	   const formData = new FormData();
                   const container = new DataTransfer();
                   const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
                   const insNo = "${insNo}", newfileGrpId = 0;
                   const salesOrdId = "${installationInfo.salesOrdId}" == "" ? "" : "${installationInfo.salesOrdId}";
                   let uploadFlag = false;

                   for(let i = 0; i < installUploadContainer.length; i++){
                       if(installUploadContainer[i].files[0]){
                           uploadFlag=true;
                           container.items.add(new File([installUploadContainer[i].files[0]], 'MOBILE_SVC_${insNo}_' + moment().format("YYYYMMDD")  + '_' + (i+1) +'.png', {type: installUploadContainer[i].files[0].type}))
                       }
                   }

                   if(uploadFlag){
                       $.each(container.files, function(n, v) {
                    	   formData.append(n, v);
                    	   formData.append("salesOrdId", salesOrdId);
                    	   formData.append("InstallEntryNo",insNo);
                    	   formData.append("atchFileGrpId", newfileGrpId);
                       });

                       fetch("/homecare/services/install/uploadInsImage.do", {
                           method: "POST",
                           body: formData
                       })
                       .then(d=>d.json())
                       .then(r=> {

                           if(r.code =="99"){
                               document.getElementById("MsgAlert").innerHTML =  "Pre-Installation is failed to submit. Please upload another image.";
                               $("#alertModalClick").click();
                               return;
                           }
                           attachment = r.fileGroupKey;
                           insertPreInsFail();
                       });
                   }else{
                       insertPreInsFail();
                   }
            }
            else{
            	window.location = "/homecare/services/install/getAcPreInsResult.do?insNo=${insNo}";
            }
        });
    })

</script>