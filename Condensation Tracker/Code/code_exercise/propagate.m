function [ particles ] = propagate(particles,sizeFrame,params)

variance_pos = normrnd(0,params.sigma_position,2,params.num_particles);
variance_vel = normrnd(0,params.sigma_velocity,2,params.num_particles);

if (params.model == 1) % constant velocity
    dt = 1;
    A = [1, 0, dt, 0;
         0, 1, 0, dt;
         0, 0, 1, 0;
         0, 0, 0, 1];
    particles = A*particles' + [variance_pos ; variance_vel];
else % no motion
    A = eye(2);
    particles = A*particles' + variance_pos;
                     
end

particles(1,:) = min(particles(1,:),sizeFrame(2)); % max x check
particles(1,:) = max(particles(1,:),0); % min x check
particles(2,:) = min(particles(2,:),sizeFrame(1)); % max y check
particles(2,:) = max(particles(2,:),0); % min y check

particles= particles';
end