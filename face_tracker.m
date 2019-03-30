function tracker = face_tracker(videoFrame);

%This function detects the face and returns region of interest

global faceDetector pointTracker numPts oldPoints bboxPoints bbox oldInliers;
global  acc_red acc_green acc_blue ret_r ret_g ret_b;
videoFrameGray = rgb2gray(videoFrame);


if numPts < 10
        % Detection mode.
        %facedetector gives the edges where the face lies in the frame.
        bbox = faceDetector(videoFrameGray);

        if ~isempty(bbox)
            % Find corner points inside the detected region.
            % detectMinEigenFeatures is a funtion which returns the corners
            % of an object using Minimum eigenvalue algorithm
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            %mycode
            bboxPolygon = reshape(bboxPoints', 1, []);
            roi = imcrop(videoFrame, bbox);
            
            redChannel = roi(:,:,1); % Red channel
            greenChannel = roi(:,:,2); % Green channel
            blueChannel = roi(:,:,3); % Blue channel
            
            avg_red = mean(redChannel, 'all');
            avg_green = mean(greenChannel, 'all');
            avg_blue = mean(blueChannel, 'all');
            
            ret_r = [ret_r, avg_red];
            ret_g = [ret_g, avg_green];
            ret_b = [ret_b, avg_blue];
            
            acc_red = [acc_red, avg_red];
            acc_green = [acc_green, avg_green];
            acc_blue = [acc_blue, avg_blue];

            
            %roi = videoFrame(bboxPoints(1:1,1:1):bboxPoints(2:2,1:1), bboxPoints(1:1,2:2):bboxPoints(3:3,2:2));
              
            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            %videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            
            %mycode - ROI, averaging, accumulation
            roi = imcrop(videoFrame, bbox);
            
            redChannel = roi(:,:,1); % Red channel
            greenChannel = roi(:,:,2); % Green channel
            blueChannel = roi(:,:,3); % Blue channel
            
            avg_red = mean(redChannel, 'all');
            avg_green = mean(greenChannel, 'all');
            avg_blue = mean(blueChannel, 'all');
            
            ret_r = [ret_r, avg_red];
            ret_g = [ret_g, avg_green];
            ret_b = [ret_b, avg_blue];
            
            acc_red = [acc_red, avg_red];
            acc_green = [acc_green, avg_green];
            acc_blue = [acc_blue, avg_blue];

            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display tracked points.
            %videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end

end
    
tracker = videoFrame;

